From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5 09/31] crypto: ccp: Build the AMD secure
 processor driver only with AMD CPU support
Date: Wed, 4 Oct 2017 23:47:52 +0200
Message-ID: <20171004214752.imwom4slkmtgxuqr@pd.tnic>
References: <20171004131412.13038-1-brijesh.singh@amd.com>
 <20171004131412.13038-10-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171004131412.13038-10-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 04, 2017 at 08:13:50AM -0500, Brijesh Singh wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> This is AMD-specific hardware so present it in Kconfig only when AMD
> CPU support is enabled or on ARM64 where it is also used.
> 
> Signed-off-by: <brijesh.singh@amd.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>

For the future, when you carry a patch from someone else, your SOB
should come after the author's. I.e.,

Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>

i.e., the first SOB is the author's and the second is yours which means,
you've handled the patch further on, like sending it upstream, for
example.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
