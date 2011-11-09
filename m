From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] ansi_cprng: enforce key != seed in fips mode
Date: Wed, 9 Nov 2011 12:07:32 +0800
Message-ID: <20111109040732.GA20408@gondor.apana.org.au>
References: <20111104105101.GA23232@hmsreliant.think-freely.org> <1320415285-4527-1-git-send-email-jarod@redhat.com> <20111104152513.GC23232@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	Stephan Mueller <smueller@atsec.com>,
	Steve Grubb <sgrubb@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:35950 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab1KIEHi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Nov 2011 23:07:38 -0500
Content-Disposition: inline
In-Reply-To: <20111104152513.GC23232@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 04, 2011 at 11:25:13AM -0400, Neil Horman wrote:
> On Fri, Nov 04, 2011 at 10:01:25AM -0400, Jarod Wilson wrote:
> > Apparently, NIST is tightening up its requirements for FIPS validation
> > with respect to RNGs. Its always been required that in fips mode, the
> > ansi cprng not be fed key and seed material that was identical, but
> > they're now interpreting FIPS 140-2, section AS07.09 as requiring that
> > the implementation itself must enforce the requirement. Easy fix, we
> > just do a memcmp of key and seed in fips_cprng_reset and call it a day.
> > 
> > v2: Per Neil's advice, ensure slen is sufficiently long before we
> > compare key and seed to avoid looking at potentially unallocated mem.
> > 
> > CC: Neil Horman <nhorman@tuxdriver.com>
> > CC: Stephan Mueller <smueller@atsec.com>
> > CC: Steve Grubb <sgrubb@redhat.com>
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> Thanks Jarod.  Adding Herbert to the cc list so he can pull this into the crypto
> tree.
> 
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Patch applied.  Jarod, please cc me in future for patches.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
