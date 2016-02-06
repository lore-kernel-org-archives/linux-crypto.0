From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/4] crypto x86/sha1_mb: Fix load failure
Date: Sat, 6 Feb 2016 15:47:01 +0800
Message-ID: <20160206074701.GD22220@gondor.apana.org.au>
References: <1454421405-19801-1-git-send-email-rui.y.wang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Rui Wang <rui.y.wang@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454421405-19801-1-git-send-email-rui.y.wang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Feb 02, 2016 at 09:56:45PM +0800, Rui Wang wrote:
>
> >From 4bcb73adbef99aada94c49f352063619aa24d43d Mon Sep 17 00:00:00 2001
> From: Rui Wang <rui.y.wang@intel.com>
> Date: Mon, 14 Dec 2015 17:22:13 +0800
> Subject: [PATCH v2 1/4] crypto x86/sha1_mb: Fix load failure
> 
> modprobe sha1_mb fails with the following message:
> 
> modprobe: ERROR: could not insert 'sha1_mb': No such device
> 
> It is because it needs to set its statesize and implement its
> import() and export() interface.
> 
> v2: remove redundant call to crypto_shash_init()
> 
> Signed-off-by: Rui Wang <rui.y.wang@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
