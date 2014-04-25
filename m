From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: Freescale SEC1 and AEAD / IPSEC
Date: Fri, 25 Apr 2014 12:03:59 -0400
Message-ID: <CACXcFmmMGpELM7vKHc5HVUSjeL1M+rVmnKia+fA-sWpBf1_bpA@mail.gmail.com>
References: <535912E1.5000109@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Kim Phillips <kim.phillips@freescale.com>,
	linux-crypto@vger.kernel.org
To: leroy christophe <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:55814 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaDYQEA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Apr 2014 12:04:00 -0400
Received: by mail-vc0-f170.google.com with SMTP id hr9so5112917vcb.29
        for <linux-crypto@vger.kernel.org>; Fri, 25 Apr 2014 09:03:59 -0700 (PDT)
In-Reply-To: <535912E1.5000109@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 24, 2014 at 9:34 AM, leroy christophe
<christophe.leroy@c-s.fr> wrote:

> I'm progressing well on the SEC1 implementation. I now have HASH (non HMAC)
> , DES and AES working properly.

Why DES? More than a decade ago, the first Linux IPsec implementation
refused to do single DES because it was known to be insecure.
http://www.freeswan.org/freeswan_trees/freeswan-1.97/doc/faq.html#noDES.faq

At that time, we had to have DES internally so we could implement triple DES.
We just did not provide single DES in the user interface or the list of cipher
suites we would negotiate.

Today you could consider dropping DES entirely since AES is so widespread,
far faster than triple DES, and thought secure. As of 2001 or so, it roughly
doubled IPsec throughput:
http://www.freeswan.org/freeswan_trees/freeswan-1.97/doc/performance.html#perf.more
Today it probably does even better; there has been a lot of work on
optimising it.

> So it is now time to look at AEAD.

A fine idea. AES-GCM is the first obvious candidate. Newer work includes:
http://tools.ietf.org/html/draft-agl-tls-chacha20poly1305-00

There is a competition for new AEAD methods, still in early stages so it
does not yet give any solid results you could implement. Likely worth a
look, though:
http://competitions.cr.yp.to/caesar.html
https://aezoo.compute.dtu.dk/doku.php

> I don't know much yet about crypto algorithm so forgive me if I ask stupid
> questions.

An area that was a problem a decade ago was forward secrecy.

http://www.freeswan.org/freeswan_trees/freeswan-1.97/doc/interop.html#req.features
"FreeS/WAN default is to provide perfect forward secrecy. ... The PFS
settings on the two ends must match. There is no provision in the
protocol for negotiating whether to use PFS; you need to either set
both ends to use it or set them both not to."

The difference is what happens if an enemy gets the keys used in
authenticating connection setup. Without PFS, that lets him obtain
actual encryption keys and read everything sent on those connections,
possibly including old messages he has archived. With PFS he gets no
message content without doing a man-in-the-middle attack (using the
authentication keys to trick servers into giving him data that lets
him get encryption keys), he has to do another such attack every time
you change keys, and there is no way to do one for old messages.

I do not know if the revised RFCs have fixed this, but I am very much
of the opinion that PFS should be the default everywhere.
