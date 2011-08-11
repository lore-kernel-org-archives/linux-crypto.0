From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: Re: RSA
Date: Thu, 11 Aug 2011 22:00:26 +0300
Message-ID: <4E4426CA.20209@intel.com>
References: <1313087453.2239.28.camel@Thor>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Michel Machado <michel@digirati.com.br>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:39431 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752449Ab1HKS7Z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2011 14:59:25 -0400
Received: by pzk33 with SMTP id 33so5124288pzk.4
        for <linux-crypto@vger.kernel.org>; Thu, 11 Aug 2011 11:59:24 -0700 (PDT)
In-Reply-To: <1313087453.2239.28.camel@Thor>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Please look to the patch just before your email...
[RFC v1.1 2/5] crypto: ksign - digital signature verification support

It implements RSA verification for IMA/EVM.
May be it would be interesting to you.

- Dmitry

On 11/08/11 21:30, Michel Machado wrote:
> Hi there,
>
>    I'm implementing a new network stack in Linux's kernel [1], and I
> need a RSA implementation to keep the guarantees of the design [2].
>
>    Searching the archive of Linux's mailing lists, I've found that
> adding RSA to the kernel has been already tried, but it was left out
> because the uses were not convincing then.
>
>    I intend to submit my work [3, 4] when I get a reasonable working
> version. Until there, could anyone point me to a working patch to add
> RSA to the kernel? The old patch [5] doesn't integrate with the current
> Crypto API.
>
>    Is there hope to have RSA added to Linux? If not for a ready use,
> it'd help to experiment with things that are still in the making.
>
> [1] http://www.cs.cmu.edu/~xia/
> [2] http://reports-archive.adm.cs.cmu.edu/anon/2011/CMU-CS-11-100.pdf
> [3] git://github.com/AltraMayor/XIA-for-Linux.git
> [4] git://github.com/AltraMayor/xiaconf.git
> [5] http://lwn.net/Articles/228892/
>
