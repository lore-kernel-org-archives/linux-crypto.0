From: Marcus Meissner <meissner@suse.de>
Subject: Re: rfc4543 testvectors in testmgr.h kernel
Date: Wed, 11 Feb 2015 10:19:42 +0100
Message-ID: <20150211091942.GM32656@suse.de>
References: <20150210162243.GH32656@suse.de>
 <54DA424A.7080909@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbbBKJTo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Feb 2015 04:19:44 -0500
Content-Disposition: inline
In-Reply-To: <54DA424A.7080909@iki.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 10, 2015 at 07:39:22PM +0200, Jussi Kivilinna wrote:
> On 10.02.2015 18:22, Marcus Meissner wrote:
> > Hi Jussi,
> > 
> > We were trying to use rfc4543(gcm(aes)) in the kernel for FIPS mode,
> > but the testvectors seem to fail.
> 
> You probably need to add '.fips_allowed = 1,' in testmgr.c for "rfc4543(gcm(aes))" to enable algorithm in fips mode.
> 
> > 
> > Did you verify that they work? Are these the ones from Page 18 of 
> > https://tools.ietf.org/html/draft-mcgrew-gcm-test-01, as there the "plaintext" 
> > and "aaad" seem to be switched?
> 
> rfc4543() wrapper constructs the aad from '.assoc' and '.input'.

We tried above and still got -2 errors.

I think "ecb(cipher_null)" also needs to set the .fips_allowed flag, so that the rfc4543 setup can pull it in.

CIao, Marcus
