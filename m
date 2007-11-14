From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling, 64bit-ization
Date: Tue, 13 Nov 2007 22:30:47 -0700
Message-ID: <200711132230.47844.vda.linux@googlemail.com>
References: <200711131534.33521.vda.linux@googlemail.com> <200711131947.09040.vda.linux@googlemail.com> <20071113.194952.229187981.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: takamiya@po.ntts.co.jp, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:2869 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbXKNFbA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Nov 2007 00:31:00 -0500
Received: by wa-out-1112.google.com with SMTP id v27so72289wah
        for <linux-crypto@vger.kernel.org>; Tue, 13 Nov 2007 21:30:59 -0800 (PST)
In-Reply-To: <20071113.194952.229187981.davem@davemloft.net>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tuesday 13 November 2007 20:49, David Miller wrote:
> From: Denys Vlasenko <vda.linux@googlemail.com>
> Date: Tue, 13 Nov 2007 19:47:08 -0700
>
> > If CONFIG_CC_OPTIMIZE_FOR_SIZE is not an acceptable method,
> > do you have other ideas?
>
> Look at ways to make the code run faster without loop unrolling?

I did it. I noticed that key setup is mostly operating on 64-bit
quantities, and provided alternative implementation which
exploits that fact. It's smaller and faster.

However, after I've done that, the question still stands:
should I unroll the loop or not?

The situation we are in now is exactly the sutiation I want to
avoid:

On Wednesday 07 November 2007 06:22, Denys Vlasenko wrote:
> > Having two versions of the cdoe is unmaintainable.  So please
> > either decide that 5% is worth it or isn't.
>
> *I* am happy with 5% speed sacrifice. I'm afraid other people won't be.
>
> I just want to escape vicious cycle of -Os people arguing with
> -O2 people to no end. I don't want somebody to come later
> and unroll the loop again. And then me to come
> and de-unroll it again...
>
> It's better for everybody to recognize that both POVs are valid,
> and have provisions for tuning size/speed tradeoff by the user
> (person which builds the binary).

That's why I made a patch where unrolling can be enabled by CONFIG_xxx.

I will resubmit the patch without de-unrolling.
Meanwhile, I'd like to ask you guys to think about ways
to make size/speed tradeoffs selectable at build time.
--
vda
