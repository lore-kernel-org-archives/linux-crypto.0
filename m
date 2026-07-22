Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0766D439F6B
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 16:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784737469; cv=none; b=hSA6FzoSuGo0kooOnTntUaiEmp2xEx5IC4+yfM+ILoLK7gd1y5dYa5wGszW4pVpBiRMWPu4j3oSclTJBaLWo1CVMObWni+sXR5Ka4tjF1eaNJtp09sUMuhGGQiVGZ8EXpquDbCSFxp2yLhR6b0mBu9mrTBLT7e6m/jtglDRON8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784737469; c=relaxed/simple;
	bh=/WyMbeV4zkcWluSOm6VoeySUkl622krFWj+pyHUbKR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U8RVCp7GJGceedR/Dyo2dMUN5weDRcWPizUdMQzkIdf/z2erE03+SkEVYEYXCBkVp9DH+LdxsBgJ0kP2lZyGrVror0HnlsykEkfrusD+ek5UsyuHZ6gwESRYKk1Alctcy66OIpquihsdYEADM+zrqtoZJg+sF76X4dIJLzQ7uVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FANNW9hx; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FANNW9hx"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47f7872abb6so1875657f8f.3
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 09:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1784737465; x=1785342265; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2igWrK3sLvehF4ssltJjwwRX17/ER74PLHHAcafs2g4=;
        b=FANNW9hxd5FsmcJOQTcafl5+lNLE6g2a/frJt6dCIXM1lB8TPh1fumMIbi2092SVqJ
         O2r1v5DdMDMLDWbUGhbldxHuAyaUtLmiTz5B8ZeBHSLoIQ9OhkJt/F1lin+1aGs2Kgxs
         U4vYO+3WXAa+HenLZJ210tUK0IofgiiD0lO377Oji2a4hV/U5DuAKOL6JhhsdXov2O43
         +uEB0Pj/vlQc7wLrld2t7LjS8kC80d9odQpR5NT0D6Z5FJRqfdHo0JGi98UEB735PZoc
         JTtVPEXwxqbvfahSc4p3D9uxL/9lV+zq/ykQNFlA866/9+SGVD0uyaEZKFa1ljiF0sXT
         DJLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784737465; x=1785342265;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2igWrK3sLvehF4ssltJjwwRX17/ER74PLHHAcafs2g4=;
        b=mj3hVyb1fJfa8q/9PWpDSrIxAs9LPqn1La99qRU8Q6jn8nx/x3L/INAKP1vcG3sG1Y
         DEUlRWsLWJ0RhOPBBz78xM80WCqAFvtqRcfK+bw4oX6X+SugXSktaxu+9nsrPSbBGivF
         Z6FN5UnUr97q1fvnRXeDVH5uGT9K5J+P83BgONz3LICJsznx5suuh7cXVf02sEPQmKFV
         hkwrFqZF5Cq+k9HSEnXHbr72rtw6B8Wqdh9r7gaUGjv2O/aQ159d528wQfmKwaCx7bEf
         vghsESc83ys1tvhux0iDMg8EqDEeAeWem1/MVDnLOgyZPTlC6/BNg12A9dZzR7AcyLUw
         V0Jw==
X-Forwarded-Encrypted: i=1; AHgh+RrLBiSY0mzHRVD/wMT8UqewTD3AVV/V+udIF4EA8mPMzuKgdAwbuZu2M6YMyp6+54AVpsnu6OUlU8alfXk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNmgFRLmnag4Z0t8W0Ra3dK5WsBFVii0x82YhEgeHVYgmUhlCs
	1yxktrxN+IDFJQEXvdCMRYG4GCtoZNQy8i10fi2OKD2LxlfnjVi9hs14zcCsZtQlRrU=
X-Gm-Gg: AR+sD10jvnpvbNXnGpsCDQjy3A5OKSzWgWOoq8igX4xsrsDSEMSgq6deNAcNZ/quAj8
	fP7giQ0g/BqshIalKwx5Q3r/t0UwrM7XiZG8sYlDNGGe9M4XXPb4LQDbqgn70nEVtqUbKtM/iTw
	jOPr+nLKubUqgrvn5NZgElEA8BMrJ4AYhef76H1gxffWQ9Zxi+ouY9XgCO2w4KqOFL0CxoMtjzz
	xYjxlTYAUu0TU3G95uFtMid7OEaRU3cg9sR6ePdzcgv4OCO7gYUt5GGJuUva1vWcXOyiqpNVZ5J
	DDGjqXDf8V2ZwpIoc8XOdiqWoA4ZkFuFHrx4MffhUdw7nU2BpzdOsfkm0FJEmi8+a0hJu6HoLAH
	wG84SvHE8uCLX8JKqa5SorAZJwFFtCNx5pm3c1i29U7C+4u4M2gSWnOZYVfwar+M21cRC3BD+6j
	Q38gBnt4WJ7ZBH
X-Received: by 2002:a05:6000:4022:b0:47f:8860:5663 with SMTP id ffacd0b85a97d-47f8860584bmr2665249f8f.34.1784737465060;
        Wed, 22 Jul 2026 09:24:25 -0700 (PDT)
Received: from linaro.org ([2a02:2454:ff24:7210:7ae3:a857:e482:495])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c531afsm6840362f8f.24.2026.07.22.09.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 09:24:23 -0700 (PDT)
Date: Wed, 22 Jul 2026 18:24:10 +0200
From: Stephan Gerhold <stephan.gerhold@linaro.org>
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Udit Tiwari <quic_utiwari@quicinc.com>,
	Md Sadre Alam <mdalam@qti.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vignesh Raghavendra <vigneshr@ti.com>, dmaengine@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	sashiko-reviews@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: Re: [PATCH v23 06/14] dmaengine: qcom: bam_dma: add support for BAM
 locking
Message-ID: <amDuqoRBg5qGafi2@linaro.org>
References: <20260721-qcom-qce-cmd-descr-v23-0-1be02deffda9@oss.qualcomm.com>
 <20260721-qcom-qce-cmd-descr-v23-6-1be02deffda9@oss.qualcomm.com>
 <20260721134853.2B2401F000E9@smtp.kernel.org>
 <amCGXUUd4VmuQRGD@linaro.org>
 <CAMRc=MfBNB0pvv1kPPcswE4Y2m7PXBO49bwJg=v0+aY=JmJKWw@mail.gmail.com>
 <amC7_M-HjVZ3sQuT@linaro.org>
 <CAMRc=MdnSyPmbK0skMx686=wSe52nnuWgCNJ0uSoKs_=HyAq-Q@mail.gmail.com>
 <amDRxPkdvbA-iVer@linaro.org>
 <CAMRc=Me523xQbfJvML9taJ-fR128SJurJS4eX9N9E9WtHF5W5Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=Me523xQbfJvML9taJ-fR128SJurJS4eX9N9E9WtHF5W5Q@mail.gmail.com>

On Wed, Jul 22, 2026 at 08:37:19AM -0700, Bartosz Golaszewski wrote:
> On Wed, 22 Jul 2026 16:20:52 +0200, Stephan Gerhold
> <stephan.gerhold@linaro.org> said:
> > On Wed, Jul 22, 2026 at 07:11:10AM -0700, Bartosz Golaszewski wrote:
> >> On Wed, 22 Jul 2026 14:47:56 +0200, Stephan Gerhold
> >> <stephan.gerhold@linaro.org> said:
> >> > On Wed, Jul 22, 2026 at 02:34:52AM -0700, Bartosz Golaszewski wrote:
> >> >> On Wed, 22 Jul 2026 10:59:09 +0200, Stephan Gerhold
> >> >> <stephan.gerhold@linaro.org> said:
> >> >> > On Tue, Jul 21, 2026 at 01:48:52PM +0000, sashiko-bot@kernel.org wrote:
> >> >> >> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
> >> >> >> - [High] State leak causing hardware misconfiguration on channel reuse due to uncleared `lock_scratchpad_addr` and hardcoded direction.
> >> >> >> - [High] Channel state corruption when `bam_slave_config` fails validation.
> >> >> >> - [High] Infinite BH workqueue loop and unratelimited log flood on memory allocation failure.
> >> >> >> - [High] DMA API violation: `lock_ce` buffer shares a cacheline with frequently CPU-modified struct members.
> >> >> >> - [Low] Unused assignment of `hdesc` in IRQ handler.
> >> >> >> --
> >> >> >>
> >> >> >> --- Patch [6]: [PATCH v23 06/14] dmaengine: qcom: bam_dma: add support for BAM locking ---
> >> >> >> commit 8b44c5e4935cbb61832adb3262df00b3b606a283
> >> >> >> Author: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> >> >> >>
> >> >> >> dmaengine: qcom: bam_dma: add support for BAM locking
> >> >> >>
> >> >> >> This commit adds support for BAM pipe locking by prepending and appending
> >> >> >> dummy command descriptors with LOCK/UNLOCK bits when starting DMA on a TX
> >> >> >> channel. It uses a peripheral-local scratchpad address communicated via slave
> >> >> >> config for the dummy writes.
> >> >> >>
> >> >> >> > diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
> >> >> >> > index f3e713a5259c2..411c60c4433e2 100644
> >> >> >> > --- a/drivers/dma/qcom/bam_dma.c
> >> >> >> > +++ b/drivers/dma/qcom/bam_dma.c
> >> >> [...]
> >> >> >> [ ... ]
> >> >> >> > @@ -1064,6 +1197,7 @@ static void bam_start_dma(struct bam_chan *bchan)
> >> >> >> >
> >> >> >> >  	lockdep_assert_held(&bchan->vc.lock);
> >> >> >> >
> >> >> >> > +	vd = vchan_next_desc(&bchan->vc);
> >> >> >> >  	if (!vd)
> >> >> >> >  		return;
> >> >> >> >
> >> >> >> > @@ -1072,6 +1206,24 @@ static void bam_start_dma(struct bam_chan *bchan)
> >> >> >> >  		return;
> >> >> >> >
> >> >> >> >  	while (vd && !IS_BUSY(bchan)) {
> >> >> >> > +		/*
> >> >> >> > +		 * Open a LOCK/UNLOCK bracket around each fresh sequence.
> >> >> >> > +		 * Sentinels inserted by bam_setup_pipe_lock() are skipped: they
> >> >> >> > +		 * already have bam_locked set and must not trigger a second pair.
> >> >> >> > +		 */
> >> >> >> > +		if (!bchan->bam_locked) {
> >> >> >> > +			ret = bam_setup_pipe_lock(bchan);
> >> >> >> > +			if (ret) {
> >> >> >> > +				dev_err_ratelimited(bdev->dev,
> >> >> >> > +					"failed to setup the pipe lock, deferring transfer: %d\n",
> >> >> >> > +					ret);
> >> >> >> > +				queue_work(system_bh_highpri_wq, &bdev->work);
> >> >> >> > +				break;
> >> >> >> > +			}
> >> >> >>
> >> >> >> [Severity: High]
> >> >> >> Does requeuing to a high-priority BH workqueue upon ENOMEM cause CPU
> >> >> >> starvation? Because system_bh_highpri_wq executes in softirq context,
> >> >> >> requeuing immediately without sleeping prevents the memory reclaim needed
> >> >> >> to resolve the GFP_NOWAIT failure, leading to an infinite spin loop.
> >> >> >>
> >> >> >
> >> >> > It looks like my suggestion to queue_work() again in the error path of
> >> >> > bam_start_dma() wasn't great if we end up causing an infinite spin loop.
> >> >> > We do need to retry somehow or report an error though, I don't think
> >> >> > aborting and leaving the desccriptors completely unhandled is an option
> >> >> > either... :(
> >> >> >
> >> >> > One option would be to try to avoid the allocation and write the lock
> >> >> > descriptors directly into the FIFO, but this will probably get really
> >> >> > messy as well, since you would need to carefully modify the FIFO
> >> >> > management in several functions ...
> >> >> >
> >> >> > I don't have a good spontaenous idea how to solve this right now. :/
> >> >> >
> >> >>
> >> >> Pre-allocate the lock descriptors (if needed) in bam_prep_slave_sg()? As in:
> >> >> call bam_make_lock_desc() in bam_prep_slave_sg(), store the descriptors and
> >> >> make bam_setup_pipe_lock() return void as it will no longer be possible for it
> >> >> to fail? It would just grab the preallocated descriptors.
> >> >>
> >> >
> >> > I considered suggesting this, but how do you know which descriptor needs
> >> > it in bam_prep_slave_sg()? It's just the allocation, afaict it doesn't
> >> > tell you anything about the order in which they will be submitted. :/
> >> >
> >> > We could always allocate the extra lock descriptors and waste the extra
> >> > memory for the descriptors that won't need it. That should work, but is
> >> > also not great ...
> >> >
> >>
> >> Oh, I was thinking about having pointers to lock/unlock descriptors in struct
> >> bam_chan and to just grab them in bam_setup_pipe_lock() when needed and then
> >> next time we enter bam_slave_prep_sg(), we see we consumed them so let's
> >> re-allocate them. And of course: don't do it at all if pipe locking is not
> >> supported.
> >>
> >
> > Sadly, I think(?) from the API perspective it is valid to
> > dmaengine_prep_slave_*() a couple of buffers and them issue them
> > separately, e.g.:
> >
> > 	desc1= dmaengine_prep_slave_*();
> > 	desc2 = dmaengine_prep_slave_*();
> >
> > 	dmaengine_submit(desc1);
> > 	dma_async_issue_pending(chan);
> >
> > 	// do a bunch of other random stuff
> > 	// bam_setup_pipe_lock() consumes lock descriptors
> >
> > 	dmaengine_submit(desc2);
> > 	dma_async_issue_pending(chan);
> >
> > In this situation, we wouldn't have any lock descriptors allocated
> > anymore?
> >
> > Thanks,
> > Stephan
> >
> 
> I'm not really sure this is correct. From:
> 
>     https://www.kernel.org/doc/html/latest/driver-api/dmaengine/client.html
> 
> "Some DMA engine drivers may hold a spinlock between a successful preparation
> and submission so it is important that these two operations are closely
> paired."
> 
> What you presented above looks like abuse of the DMA engine API in light of
> this statement. I also haven't found any place in the kernel where this would
> happen.
> 
> What the docs say is legal is preparing/submitting a new transaction from
> a completion callback but in this case the lock/unlock descriptors will be
> refilled by the call to prep_slave_sg().
> 
> I would go with pre-allocated descriptors references from bam_chan,
> re-allocated (if needed) on each prep_slave_sg() and just WARN() or even BUG()
> if we ever end up not having any descriptors ready.
> 

Ok, thanks for checking!

FWIW, I couldn't stop myself trying to finish my "write lock descriptors
directly into FIFO" idea, once I started I was curious how it would turn
out. I think it's actually quite elegant, the loop in bam_start_dma() is
wrapped with LOCK and UNLOCK, later process_channel_irqs() looks at the
FIFO again and just skips over these descriptors. lock_ce is allocated
once at channel creation time, no other allocations are needed. (Could
probably move lock_ce allocation to slave_config() so it's allocated
only when locking is configured for a channel).

See diff below. It doesn't crash badly in a quick test, but didn't check
in detail if the locking is actually working correctly. :')

I'm okay with whatever is "free of known races" and works with the use
cases we have, so use/adapt whatever you like best.

If you want to use this, feel free to add
Co-developed-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>

Good luck! :D

Thanks,
Stephan

---
 drivers/dma/qcom/bam_dma.c       | 94 ++++++++++++++++++++++++++++++--
 include/linux/dma/qcom_bam_dma.h | 15 +++++
 2 files changed, 104 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index f3e713a5259c..864531dca2a6 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -28,11 +28,13 @@
 #include <linux/clk.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
+#include <linux/dma/qcom_bam_dma.h>
 #include <linux/dmaengine.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/lockdep.h>
 #include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/of_dma.h>
@@ -60,6 +62,10 @@ struct bam_desc_hw {
 #define DESC_FLAG_EOB BIT(13)
 #define DESC_FLAG_NWD BIT(12)
 #define DESC_FLAG_CMD BIT(11)
+#define DESC_FLAG_LOCK BIT(10)
+#define DESC_FLAG_UNLOCK BIT(9)
+
+#define DESC_FLAG_LOCK_MASK (DESC_FLAG_LOCK | DESC_FLAG_UNLOCK)
 
 struct bam_async_desc {
 	struct virt_dma_desc vd;
@@ -425,6 +431,12 @@ struct bam_chan {
 	struct list_head desc_list;
 
 	struct list_head node;
+
+	/* BAM locking infrastructure */
+	struct bam_cmd_element *lock_ce;
+	dma_addr_t lock_ce_phys;
+	bool locking_enabled;
+	bool bam_locked;
 };
 
 static inline struct bam_chan *to_bam_chan(struct dma_chan *common)
@@ -531,6 +543,7 @@ static void bam_reset_channel(struct bam_chan *bchan)
 
 	/* make sure hw is initialized when channel is used the first time  */
 	bchan->initialized = 0;
+	bchan->bam_locked = false;
 }
 
 /**
@@ -607,6 +620,17 @@ static int bam_alloc_chan(struct dma_chan *chan)
 		return -ENOMEM;
 	}
 
+	if (bdev->dev_data->pipe_lock_supported) {
+		bchan->lock_ce = dma_alloc_wc(bdev->dev, sizeof(*bchan->lock_ce),
+					      &bchan->lock_ce_phys, GFP_KERNEL);
+		if (!bchan->lock_ce) {
+			dev_err(bdev->dev, "Failed to allocate lock CE\n");
+			dma_free_wc(bdev->dev, BAM_DESC_FIFO_SIZE, bchan->fifo_virt, bchan->fifo_phys);
+			bchan->fifo_virt = NULL;
+			return -ENOMEM;
+		}
+	}
+
 	if (bdev->active_channels++ == 0 && bdev->powered_remotely)
 		bam_reset(bdev);
 
@@ -644,6 +668,10 @@ static void bam_free_chan(struct dma_chan *chan)
 	dma_free_wc(bdev->dev, BAM_DESC_FIFO_SIZE, bchan->fifo_virt,
 		    bchan->fifo_phys);
 	bchan->fifo_virt = NULL;
+	if (bchan->lock_ce) {
+		dma_free_wc(bdev->dev, sizeof(*bchan->lock_ce), bchan->lock_ce, bchan->lock_ce_phys);
+		bchan->lock_ce = NULL;
+	}
 
 	/* mask irq for pipe/channel */
 	val = readl_relaxed(bam_addr(bdev, 0, BAM_IRQ_SRCS_MSK_EE));
@@ -676,10 +704,29 @@ static void bam_free_chan(struct dma_chan *chan)
 static int bam_slave_config(struct dma_chan *chan,
 			    struct dma_slave_config *cfg)
 {
+	struct bam_config *peripheral_cfg = cfg->peripheral_config;
 	struct bam_chan *bchan = to_bam_chan(chan);
 
 	guard(spinlock_irqsave)(&bchan->vc.lock);
 
+	/*
+	 * This is required to setup the pipe locking and must be done even
+	 * before the first call to bam_start_dma().
+	 */
+	if (peripheral_cfg && cfg->peripheral_size == sizeof(*peripheral_cfg)) {
+		if (cfg->direction != DMA_MEM_TO_DEV)
+			return -EINVAL;
+
+		if (bchan->lock_ce) {
+			bam_prep_ce_le32(bchan->lock_ce, peripheral_cfg->lock_scratchpad_addr,
+					 BAM_WRITE_COMMAND, 0);
+			bchan->locking_enabled = true;
+		}
+	} else {
+		/* Don't touch lock_ce here, it might still be used by issued descriptors */
+		bchan->locking_enabled = false;
+	}
+
 	memcpy(&bchan->slave, cfg, sizeof(*cfg));
 	bchan->reconfigure = 1;
 
@@ -879,6 +926,7 @@ static u32 process_channel_irqs(struct bam_device *bdev)
 
 	for (i = 0; i < bdev->num_channels; i++) {
 		struct bam_chan *bchan = &bdev->channels[i];
+		struct bam_desc_hw *fifo = PTR_ALIGN(bchan->fifo_virt, sizeof(struct bam_desc_hw));
 
 		if (!(srcs & BIT(i)))
 			continue;
@@ -902,6 +950,12 @@ static u32 process_channel_irqs(struct bam_device *bdev)
 
 		list_for_each_entry_safe(async_desc, tmp,
 					 &bchan->desc_list, desc_node) {
+			/* Skip over lock descriptors in the FIFO */
+			while (avail > 0 && le16_to_cpu(fifo[bchan->head].flags) & DESC_FLAG_LOCK_MASK) {
+				bchan->head = (bchan->head + 1) % MAX_DESCRIPTORS;
+				avail--;
+			}
+
 			/* Not enough data to read */
 			if (avail < async_desc->xfer_len)
 				break;
@@ -1046,6 +1100,16 @@ static void bam_apply_new_config(struct bam_chan *bchan,
 	bchan->reconfigure = 0;
 }
 
+static void bam_fifo_write_lock(struct bam_chan *bchan, u16 flags)
+{
+	struct bam_desc_hw *fifo = PTR_ALIGN(bchan->fifo_virt, sizeof(struct bam_desc_hw));
+
+	fifo[bchan->tail].addr = cpu_to_le32(bchan->lock_ce_phys);
+	fifo[bchan->tail].size = cpu_to_le16(sizeof(struct bam_cmd_element));
+	fifo[bchan->tail].flags = cpu_to_le16(DESC_FLAG_CMD | flags);
+	bchan->tail = (bchan->tail + 1) % MAX_DESCRIPTORS;
+}
+
 /**
  * bam_start_dma - start next transaction
  * @bchan: bam dma channel
@@ -1064,13 +1128,23 @@ static void bam_start_dma(struct bam_chan *bchan)
 
 	lockdep_assert_held(&bchan->vc.lock);
 
-	if (!vd)
+	if (IS_BUSY(bchan) || (!vd && !bchan->bam_locked))
 		return;
 
 	ret = pm_runtime_get_sync(bdev->dev);
 	if (ret < 0)
 		return;
 
+	if (bchan->locking_enabled && !bchan->bam_locked) {
+		/* Defer locking until we also have space for a data descriptor */
+		avail = CIRC_SPACE(bchan->tail, bchan->head, MAX_DESCRIPTORS + 1);
+		if (avail < 2)
+			goto out;
+
+		bam_fifo_write_lock(bchan, DESC_FLAG_LOCK);
+		bchan->bam_locked = true;
+	}
+
 	while (vd && !IS_BUSY(bchan)) {
 		list_del(&vd->node);
 
@@ -1135,11 +1209,23 @@ static void bam_start_dma(struct bam_chan *bchan)
 		list_add_tail(&async_desc->desc_node, &bchan->desc_list);
 	}
 
+	/*
+	 * Append unlock if there are no more descriptors queued.
+	 * There is no need to request an interrupt when unlock finishes,
+	 * process_channel_irqs() will handle it together with the next real
+	 * data descriptors.
+	 */
+	if (bchan->bam_locked && !vd && !IS_BUSY(bchan)) {
+		bam_fifo_write_lock(bchan, DESC_FLAG_UNLOCK);
+		bchan->bam_locked = false;
+	}
+
 	/* ensure descriptor writes and dma start not reordered */
 	wmb();
 	writel_relaxed(bchan->tail * sizeof(struct bam_desc_hw),
 			bam_addr(bdev, bchan->id, BAM_P_EVNT_REG));
 
+out:
 	pm_runtime_mark_last_busy(bdev->dev);
 	pm_runtime_put_autosuspend(bdev->dev);
 }
@@ -1161,9 +1247,7 @@ static void bam_dma_work(struct work_struct *work)
 		bchan = &bdev->channels[i];
 
 		guard(spinlock_irqsave)(&bchan->vc.lock);
-
-		if (!list_empty(&bchan->vc.desc_issued) && !IS_BUSY(bchan))
-			bam_start_dma(bchan);
+		bam_start_dma(bchan);
 	}
 }
 
@@ -1180,7 +1264,7 @@ static void bam_issue_pending(struct dma_chan *chan)
 	guard(spinlock_irqsave)(&bchan->vc.lock);
 
 	/* if work pending and idle, start a transaction */
-	if (vchan_issue_pending(&bchan->vc) && !IS_BUSY(bchan))
+	if (vchan_issue_pending(&bchan->vc))
 		bam_start_dma(bchan);
 }
 
diff --git a/include/linux/dma/qcom_bam_dma.h b/include/linux/dma/qcom_bam_dma.h
index 68fc0e643b1b..188f667cad99 100644
--- a/include/linux/dma/qcom_bam_dma.h
+++ b/include/linux/dma/qcom_bam_dma.h
@@ -6,6 +6,8 @@
 #ifndef _QCOM_BAM_DMA_H
 #define _QCOM_BAM_DMA_H
 
+#include <linux/dmaengine.h>
+
 #include <asm/byteorder.h>
 
 /*
@@ -34,6 +36,19 @@ enum bam_command_type {
 	BAM_READ_COMMAND,
 };
 
+/**
+ * struct bam_config - BAM DMA peripheral config.
+ *
+ * @lock_scratchpad_addr: Peripheral-local register address to use for dummy
+ *                        write operations when queuing command descriptors
+ *                        with LOCK/UNLOCK bits set. This is not a system
+ *                        physical address: BAM command descriptors only
+ *                        encode a 24-bit address relative to the peripheral.
+ */
+struct bam_config {
+	u32 lock_scratchpad_addr;
+};
+
 /*
  * prep_bam_ce_le32 - Wrapper function to prepare a single BAM command
  * element with the data already in le32 format.
-- 
2.54.0

