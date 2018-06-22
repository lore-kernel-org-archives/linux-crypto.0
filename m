From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH 1/2] hwrng: msm: add a spinlock and support for blocking
 reads
Date: Fri, 22 Jun 2018 09:54:07 +0530
Message-ID: <20180622042407.GG27187@vkoul-mobl>
References: <1529594276-12210-1-git-send-email-timur@codeaurora.org>
 <20180622041712.GE27187@vkoul-mobl>
 <efc93d58-4671-2c51-75d4-a19759ab0f0c@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: timur@kernel.org, linux-arm-msm@vger.kernel.org, swboyd@chromium.org,
 linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
 linux-arm-kernel@lists.infradead.org
To: Timur Tabi <timur@codeaurora.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <efc93d58-4671-2c51-75d4-a19759ab0f0c@codeaurora.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On 21-06-18, 23:18, Timur Tabi wrote:
> On 6/21/18 11:17 PM, Vinod wrote:
> > this should be a separate patch
> 
> What exactly should be a separate patch?  This part?
> 
> -	rng->hwrng.name = KBUILD_MODNAME,
> -	rng->hwrng.init = msm_rng_init,
> -	rng->hwrng.cleanup = msm_rng_cleanup,
> -	rng->hwrng.read = msm_rng_read,
> +	rng->hwrng.name = KBUILD_MODNAME;
> +	rng->hwrng.init = msm_rng_init;
> +	rng->hwrng.cleanup = msm_rng_cleanup;
> +	rng->hwrng.read = msm_rng_read;

yes

-- 
~Vinod
