From: Michel Machado <michel@digirati.com.br>
Subject: Re: RSA
Date: Thu, 11 Aug 2011 16:01:09 -0400
Message-ID: <1313092869.2239.36.camel@Thor>
References: <1313087453.2239.28.camel@Thor>  <4E4426CA.20209@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mta62.f1.k8.com.br ([187.16.23.94]:55679 "EHLO
	mta62.f1.k8.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab1HKUBO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2011 16:01:14 -0400
In-Reply-To: <4E4426CA.20209@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Dmitry,

   Thanks for pointing out that patch. I does make bringing a full RSA
API into the kernel easier, but it doesn't do it. I may end up doing it
myself, and could certainly use the MPI library you're adding with that
patch, but I'd rather not since I already have a lot on my plate.

-- 
[ ]'s
Michel Machado


On Thu, 2011-08-11 at 22:00 +0300, Dmitry Kasatkin wrote:
> Hi,
> 
> Please look to the patch just before your email...
> [RFC v1.1 2/5] crypto: ksign - digital signature verification support
> 
> It implements RSA verification for IMA/EVM.
> May be it would be interesting to you.
> 
> - Dmitry
> 
> On 11/08/11 21:30, Michel Machado wrote:
> > Hi there,
> >
> >    I'm implementing a new network stack in Linux's kernel [1], and I
> > need a RSA implementation to keep the guarantees of the design [2].
> >
> >    Searching the archive of Linux's mailing lists, I've found that
> > adding RSA to the kernel has been already tried, but it was left out
> > because the uses were not convincing then.
> >
> >    I intend to submit my work [3, 4] when I get a reasonable working
> > version. Until there, could anyone point me to a working patch to add
> > RSA to the kernel? The old patch [5] doesn't integrate with the current
> > Crypto API.
> >
> >    Is there hope to have RSA added to Linux? If not for a ready use,
> > it'd help to experiment with things that are still in the making.
> >
> > [1] http://www.cs.cmu.edu/~xia/
> > [2] http://reports-archive.adm.cs.cmu.edu/anon/2011/CMU-CS-11-100.pdf
> > [3] git://github.com/AltraMayor/XIA-for-Linux.git
> > [4] git://github.com/AltraMayor/xiaconf.git
> > [5] http://lwn.net/Articles/228892/
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
