From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 4/4] crypto: testmgr - Add a test case for
 import()/export()
Date: Sat, 6 Feb 2016 15:47:49 +0800
Message-ID: <20160206074749.GG22220@gondor.apana.org.au>
References: <20160202144448.GB17909@gondor.apana.org.au>
 <7a0ac9250bd971a5451fb856322cfd0e5b0b52b8.1454494348.git.rui.y.wang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Rui Wang <rui.y.wang@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7a0ac9250bd971a5451fb856322cfd0e5b0b52b8.1454494348.git.rui.y.wang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Feb 03, 2016 at 06:26:57PM +0800, Rui Wang wrote:
> Modify __test_hash() so that hash import/export can be tested
> from within the kernel. The test is unconditionally done when
> a struct hash_testvec has its .np > 1.
> 
> v3: make the test unconditional
> v2: Leverage template[i].np as suggested by Tim Chen
> 
> Signed-off-by: Rui Wang <rui.y.wang@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
