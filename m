From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: RFC: redesigning random(4)
Date: Mon, 12 Dec 2011 13:46:33 +0800
Message-ID: <CACXcFmnsjX6Pj7a4OWOoufcSc+Kx9iY12anTqNK92Ydb1gshjQ@mail.gmail.com>
References: <CACXcFm=yUwYY+RvDTFk+BC8ecwcO0m-0d=LxRgrWNB+Vydthbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Ted Ts'o" <tytso@mit.edu>, Matt Mackall <mpm@selenic.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63811 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab1LLFqe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Dec 2011 00:46:34 -0500
Received: by ghbf1 with SMTP id f1so696456ghb.19
        for <linux-crypto@vger.kernel.org>; Sun, 11 Dec 2011 21:46:33 -0800 (PST)
In-Reply-To: <CACXcFm=yUwYY+RvDTFk+BC8ecwcO0m-0d=LxRgrWNB+Vydthbg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 29, 2011 at 2:46 PM, Sandy Harris <sandyinchina@gmail.com> wrote:

> I have been thinking about how random(4) might be redesigned ...
>
> ... make the input
> pool use Skein (or another SHA-3 candidate) and the output pools a
> modified counter-mode AES.

I now actually have most of the code for that and a substantial
rationale document, both in a first draft sort of state.

I have worked out how to use a block cipher in a way that has
the hard-to-invert property and does not either lose state when
it rekeys or encrypt successive counter values with a small
Hamming difference. It is fairly complex.

> Currently the driver uses SHA-1 for all three. ,,,

Having looked at the block cipher method in some detail, I've now
concluded that it is better to just use a hash which is non-invertible
by design and does not make analysis more difficult.

I may eventually have code & rationale for that too, but almost
certainly not soon.
