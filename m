From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH 1/2] hwrng: msm: add a spinlock and support for blocking
 reads
Date: Thu, 21 Jun 2018 23:18:52 -0500
Message-ID: <efc93d58-4671-2c51-75d4-a19759ab0f0c@codeaurora.org>
References: <1529594276-12210-1-git-send-email-timur@codeaurora.org>
 <20180622041712.GE27187@vkoul-mobl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: timur@kernel.org, linux-arm-msm@vger.kernel.org, swboyd@chromium.org,
 linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
 linux-arm-kernel@lists.infradead.org
To: Vinod <vkoul@kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180622041712.GE27187@vkoul-mobl>
Content-Language: en-US
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

On 6/21/18 11:17 PM, Vinod wrote:
> this should be a separate patch

What exactly should be a separate patch?  This part?

-	rng->hwrng.name = KBUILD_MODNAME,
-	rng->hwrng.init = msm_rng_init,
-	rng->hwrng.cleanup = msm_rng_cleanup,
-	rng->hwrng.read = msm_rng_read,
+	rng->hwrng.name = KBUILD_MODNAME;
+	rng->hwrng.init = msm_rng_init;
+	rng->hwrng.cleanup = msm_rng_cleanup;
+	rng->hwrng.read = msm_rng_read;

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc.  Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
