From: "Tan Swee Heng" <thesweeheng@gmail.com>
Subject: Re: [PATCH 2/2] salsa20_i586: Salsa20 stream cipher algorithm (i586 version)
Date: Sun, 9 Dec 2007 02:13:40 +0800
Message-ID: <fd3e431c0712081013n731447bap600c2157fd036cb6@mail.gmail.com>
References: <fd3e431c0712051231h44c7bc6epa2f526116cf2c47@mail.gmail.com>
	 <20071205214947.GA20246@Chamillionaire.breakpoint.cc>
	 <fd3e431c0712070902s202f2369l73d1bcd9302600de@mail.gmail.com>
	 <20071207184432.GE24292@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Sebastian Siewior" <linux-crypto@ml.breakpoint.cc>,
	"Tan Swee Heng" <thesweeheng@gmail.com>,
	"Herbert Xu" <herbert@gondor.apana.org.au>,
	"Linux Crypto" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.235]:61185 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbXLHSNl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 8 Dec 2007 13:13:41 -0500
Received: by wr-out-0506.google.com with SMTP id c49so881748wra
        for <linux-crypto@vger.kernel.org>; Sat, 08 Dec 2007 10:13:40 -0800 (PST)
In-Reply-To: <20071207184432.GE24292@Chamillionaire.breakpoint.cc>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Sebastian,

On Dec 8, 2007 2:44 AM, Sebastian Siewior <linux-crypto@ml.breakpoint.cc> wrote:
> >The keysetup() should be the same as the C version... except that I've
> >previously modified the C version to use key length in bytes while the
> >assembly version uses bits! :-) I could change the C code back. But I
> >personally prefer to use the assembly version since it was distributed
> >as a "self-contained and complete solution" in Bernstein's
> >"salsa20.s".
> I would go for the smaller files. That's why merged the AES code
> earlier.
I've seen your good work with the AES code. But I will stick with the
assembly version for the time being... at least until I've done the
Salsa x86-64 version and perhaps a few more eSTREAM ciphers.

> I would not mind modifing the source code for the greated good :) Should
> you make a mistake than the test vectors should detect them.
Test vectors are great for catching general bugs (wrong S-box entry,
wrong transformation, etc) but they can be weak at boundary conditions
(an extra byte mistakenly written at the end of the output buffer) and
against malicious intent (malicious code added without breaking
crypto). Since I don't expect people to trust a newbie like me, I'd
rather stick to not modifying the original assembly code too much. :-)

> After all, you modified the C version and s/keysize/bits.
With hindsight, I wish I had not modified the keysize bits in the C
version. It was the source of a bug while I was writing up the i586
patch (I forgot to multiply keylen by 8). So I may revert them
eventually to make them consistent with the assembly version. :-)

Swee Heng
