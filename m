From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 2/2] add ansi_cprng test vectors
Date: Wed, 29 Apr 2009 06:56:16 -0400
Message-ID: <20090429105616.GF7227@hmsreliant.think-freely.org>
References: <200904282127.33190.jarod@redhat.com> <200904282132.10884.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47646 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444AbZD2K4Y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Apr 2009 06:56:24 -0400
Content-Disposition: inline
In-Reply-To: <200904282132.10884.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 28, 2009 at 09:32:10PM -0400, Jarod Wilson wrote:
> Add ANSI X9.31 Continuous Pseudo-Random Number Generator (AES mode),
> aka 'ansi_cprng' test vectors, taken from Appendix B.2.9 and B.2.10
> of the NIST RNGVS document, found here:
>     http://csrc.nist.gov/groups/STM/cavp/documents/rng/RNGVS.pdf
> 
> Successfully tested against both the cryptodev-2.6 tree and a Red
> Hat Enterprise Linux 5.4 kernel, via 'modprobe tcrypt mode=150'.
> 
> The selection of 150 was semi-arbitrary, didn't seem like it should
> go any place in particular, so I started a new range for rng tests.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
> 
