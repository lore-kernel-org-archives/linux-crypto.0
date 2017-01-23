From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] x86/crypto: fix %progbits -> @progbits
Date: Mon, 23 Jan 2017 23:00:31 +0800
Message-ID: <20170123150031.GF20806@gondor.apana.org.au>
References: <20170119212805.18049-1-dvlasenk@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Xiaodong Liu <xiaodong.liu@intel.com>,
        Megha Dey <megha.dey@intel.com>,
        George Spelvin <linux@horizon.com>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
To: Denys Vlasenko <dvlasenk@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170119212805.18049-1-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jan 19, 2017 at 10:28:05PM +0100, Denys Vlasenko wrote:
> %progbits form is used on ARM (where @ is a comment char).
> 
> x86 consistently uses @progbits everywhere else.
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
