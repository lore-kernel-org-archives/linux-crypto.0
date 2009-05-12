From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 1/2 v2] crypto: mark algs allowed in fips mode
Date: Tue, 12 May 2009 15:08:23 -0400
Message-ID: <20090512190823.GF5019@hmsreliant.think-freely.org>
References: <200905110952.44273.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755553AbZELTIx@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200905110952.44273.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, May 11, 2009 at 09:52:43AM -0400, Jarod Wilson wrote:
> Set the fips_allowed flag in testmgr.c's alg_test_descs[] for algs
> that are allowed to be used when in fips mode.
> 
> One caveat: des isn't actually allowed anymore, but des (and thus also
> ecb(des)) has to be permitted, because disallowing them results in
> des3_ede being unable to properly register (see des module init func).
> 
> Also, crc32 isn't technically on the fips approved list, but I think
> it gets used in various places that necessitate it being allowed.
> 
> This list is based on
> http://csrc.nist.gov/groups/STM/cavp/index.html
> 
> Important note: allowed/approved here does NOT mean "validated", just
> that its an alg that *could* be validated.
> 
> Resending with properly updated patch v2 tag.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> 
