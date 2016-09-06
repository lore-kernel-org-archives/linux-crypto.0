From: Mathias Krause <minipli@googlemail.com>
Subject: echainiv not working as supposed to be?
Date: Tue, 6 Sep 2016 14:24:59 +0200
Message-ID: <CA+rthh9_=PsJgZDtfoHQsaFZ2fH2hz4w_sbhn8fnx7a3LOatXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yb0-f171.google.com ([209.85.213.171]:36363 "EHLO
        mail-yb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753617AbcIFMZA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Sep 2016 08:25:00 -0400
Received: by mail-yb0-f171.google.com with SMTP id 125so76860278ybe.3
        for <linux-crypto@vger.kernel.org>; Tue, 06 Sep 2016 05:25:00 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I'm a little bit confused on how echainiv is supposed to work. I think
it's doing a few things wrongly, I just can't decide what's actually
wrong as the intended mode of operation is unclear to me. At least,
as-is, the code isn't quite operating as advertised in the comment at
the top of the file.

So, in hope you could enlighten me, here's my understanding of the
current _implementation_ of echainiv (assuming aligned req->iv, for
simplicity):

For each request it XORs the salt into the provided IV (req->iv). For
ESP the provided IV is the sequence number or, at least, parts of it.
The thus modified IV gets written into the *destination* buffer
(req->dst) which might be a different buffer than the source buffer
(not in the ESP case, though, as it passes the same sg for src and
dst). Afterwards, the per-cpu IV gets copied over into req->iv,
effectively overwriting the generated XORed value. Then the inner
crypto request gets initiated which may finish synchronously or
asynchronously. Either way, the per-cpu IV gets updated with the new
value from subreq->iv, which should be equal to req->iv in the normal
case.

Things that are unclear to me:

1/ Why is the XORed IV written to the destination buffer and not the
source buffer? Isn't the sub-request supposed to use the IV from
either req->src or req->iv -- and especially *not* from req->dst?

2/ Why does the XORed IV gets overwritten with the per-cpu IV prior
passing it on to the sub-request, making all possible IV locations in
req->src, req->dst and req->iv *all* be different?

Moreover, the behaviour of 2/ actually leads to the fact, that the
very first IV on each CPU will be a null IV -- not a salted sequence
number. All following IVs will be the result of the (or better "some")
sub-request's IV update, stored into the per-cpu variable -- still no
salted sequence numbers, though.

That behaviour is a bug, IMHO, as this clearly differs from what is
described in the comment. However, I'm uncertain on how to fix it, as
the intended mode of operation is unclear to me... Should only the
first IV of each crypto transform be the salted sequence number and
all following the result of the sub-request's IV update, therefore not
stored in a single per-cpu variable but some echainiv context specific
one?

3/ Why is echainiv using per-cpu IVs in the first place? Shouldn't
those be crypto context specific? Currently we're happily mixing IVs
from different transforms (with possibly different IV sizes!) with
each other via the per-cpu variables. That might be an "issue" if one
echainiv user can maliciously mess with the IVs of another user, e.g.
via AF_ALG.

So, should echainiv use a per-context per-cpu array instead that --
for simplicity -- gets initialised with random bytes and will be
updated as it's now, just not with a single global per-cpu array, but
a per-context one?

That would allow us to still have a lock-less IV generator but one
that cannot be accidentally / maliciously be tampered with by other
echainiv users.


Thanks,
Mathias
