From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: padlock: fix for non-64byte aligned data
Date: Wed, 8 Dec 2010 09:52:51 +0800
Message-ID: <20101208015251.GA12399@gondor.apana.org.au>
References: <1288893036-31704-1-git-send-email-phil@nwl.cc> <20101104184606.GA1994@gondor.apana.org.au> <20101105141238.GG29793@orbit.nwl.cc> <20101202061441.GA22378@gondor.apana.org.au> <20101207104141.GA24946@orbit.nwl.cc> <20101207113956.GA6128@gondor.apana.org.au> <20101207134057.GB24946@orbit.nwl.cc> <20101208000813.GC10791@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Sutter <phil@nwl.cc>, linux-crypto@vger.kernel.org,
	Chuck Ebbert <cebbert@redhat.com>,
	Nico Erfurth <ne@erfurth.eu>, Michal Ludvig <michal@logix.cz>
To: Harald Welte <HaraldWelte@viatech.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:59860 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab0LHBw7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Dec 2010 20:52:59 -0500
Content-Disposition: inline
In-Reply-To: <20101208000813.GC10791@prithivi.gnumonks.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 08, 2010 at 08:08:13AM +0800, Harald Welte wrote:
>
> Is there a list of machines (/proc/cpuinfo) on which the problem has shown up
> so far?

Yes, this is the one that's show the problem:

| -bash-4.0# cat /proc/cpuinfo 
| processor     : 0
| vendor_id     : CentaurHauls
| cpu family    : 6
| model         : 15
| model name    : VIA Nano processor L2200@1600MHz
| stepping      : 2
| cpu MHz       : 1599.696
| cache size    : 1024 KB
| fdiv_bug      : no
| hlt_bug       : no
| f00f_bug      : no
| coma_bug      : no
| fpu           : yes
| fpu_exception : yes
| cpuid level   : 10
| wp            : yes
| flags         : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush acpi mmx fxsr sse sse2 ss tm syscall nx fxsr_opt rdtscp lm constant_tsc rep_good pni monitor est tm2 ssse3 cx16 xtpr rng rng_en ace ace_en ace2 phe phe_en lahf_lm
| bogomips      : 3199.39
| clflush size  : 64
| cache_alignment       : 128
| address sizes : 36 bits physical, 48 bits virtual
| power management:

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
