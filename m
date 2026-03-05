Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3933B3CE4BC
	for <linux-crypto@vger.kernel.org>; Thu,  5 Mar 2026 16:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772727394; cv=none; b=Wd+q2FSyDBW/Py0FCmj6BJQnfvJmhOIemrUn6I4wsfpe5jU0NZ+36F+DpqQg1AsSPU4gm8jj19uSGc1qF2TWZBwy03gk1D1N9NkNVHrcpjP1X3D2Cl7U5vzLRRgX3EPCooWqo16B8Vy5gBEcaZOBxmVSrq0GEp+NTUpRvCsdiBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772727394; c=relaxed/simple;
	bh=OyXn7u04gURNhHmDyflhOHXJEe2t/LqnNgA7VgcSgiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KyqkSDzusAMa1LUf0nOsyaImej/XMDfwFJv9X8qU8ZlY8wTPK0E55WDo8PGDf5Kj2U2iWo5HsG0BwZrOwotsoKC9hC4trgbLXJGRIE870vLKXm6o7UGwZ03d+zF4rxYhR04tC3GiARoSGTHXyrN3j4PuXZDyYi2dsLDCdItSjxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Go+Pv1ib; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Go+Pv1ib"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-483a233819aso81216355e9.3
        for <linux-crypto@vger.kernel.org>; Thu, 05 Mar 2026 08:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1772727391; x=1773332191; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Yx4AyhOAgyJue9ackXDxB6qNVZ3mjjFPXiVKLeWDVo0=;
        b=Go+Pv1ib0IlacQVXuCFjAE8f9U3bQ9y771xp6u8SE/RXBvdB/O68hwuduZnxmfmq3r
         FXxSXrO1C046wnGJA6ZXTHhGW/s+9lZjXeKNgwtORQRdRCWFgsw1XSVKMJVy0vLKN/No
         774B3pSxWIyN0Wb68C0ACHXGmPIPib4rM5jPZK8LIcjR/yIDl5ldDyZviIySaGtnnZwB
         irP1R9zzCaBI6Ikj5+zgMGIfNx6HCZL9NKWBQ3q38nU48t7EyVFvBJmAXmQjs4eLSiCC
         B66pyEEqnrUSDTtTEB57PzQvIUsVNfwvPmR+LaVT7NWPlg34S88zmyV6Ux7CMGM0u61j
         ILZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772727391; x=1773332191;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yx4AyhOAgyJue9ackXDxB6qNVZ3mjjFPXiVKLeWDVo0=;
        b=WP1wB3NMuOvZDKHslEfPNtB0rzxKq9zqaPyoNQnC+fTQ1vTK47PMcRAaHY2KmgCZXr
         uTZgUeQruOdI9Eie+J94EujusE1lXI3IcwMpjefDU3TXOPIwGZj8kGL8CzwofeZtPKN7
         QW7dw+P3rFquTov/w0OqN5mAsJQWN7N6Ex+LAJ4lPpT40apPav7y7VIHHAJs8yvzta7f
         BB9JyRc1NBPNPY6IBz7ioF2aLZ+6y58C++li+j5XI1YnTNv3FzqSmnQr1NJMhqTG2AQQ
         wm8M/Qy2f0cxyN/zVOpG/Xq3xWWr5GeRopmjwg6TZDNbX/F0ZBou0qr6trEXTHEDAunM
         jy4w==
X-Forwarded-Encrypted: i=1; AJvYcCWqgcQ0wmKmXeR6eySs8uHKY2SH8kN+9ooa2MjZn5f8TFOJjfD61XnSmL6RoeYa/dCZEeotgru3jRA16RI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmhzuP/pU77aOSIYURHuGci4OUC7leo2BIs0BHhxXHeM2e/REo
	c4ME2pnSi7Dnay2hR0useluvlVW7dIPv5cYmwSZO+0ahTFzKbeFxCvI5Njz296DTcOA=
X-Gm-Gg: ATEYQzxSlXFaHv2wPurYbWrDoeVVpuNFiHrg5akL3LxqpzLt8Js1RJmur3AzNPFCMX+
	0ct8WrTC6QYztsJTQEWrsEhvmRe7TXuWmgr8rY3Qz6kU7OC9DGzSyka6hMkphnwePlJJIJHO6Yv
	RLW/8pVsbQg+uBqn4j4ldI6aJqJhMaFfF4X3IF9PsPZdjOnY6QtpdnvVRlbMi9vo5fjyjSoIEcs
	ksHCTqDoc4xt72LU7/Al/MqbyBT/eCJ0lhCZqrgxRXfwQHIFIVeOcQyegxPHqbZz2PigSxP2avH
	FGIn7eXDaDMUvDLVAPlSZMu5u3h3U6M4zymdDVjI4mNB0Crh/Ia3GrYzOkHGIsDn32h7Zz5lWQO
	JPVqo1qhI1kX7OWfbCgpJ2oKlJLaCTUXQXZmZMuIr6OcOoD02ysgf6Nw8yZfSBgAIjzilWVJfeH
	bVzk7y3s2A3f2GwRZYfxC+V7NU26fU
X-Received: by 2002:a05:600c:1f13:b0:480:4a90:1afe with SMTP id 5b1f17b1804b1-485198bab53mr105777125e9.34.1772727390462;
        Thu, 05 Mar 2026 08:16:30 -0800 (PST)
Received: from linaro.org ([77.64.146.193])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4851a8d64dbsm55344325e9.3.2026.03.05.08.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 08:16:29 -0800 (PST)
Date: Thu, 5 Mar 2026 17:15:43 +0100
From: Stephan Gerhold <stephan.gerhold@linaro.org>
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Udit Tiwari <quic_utiwari@quicinc.com>,
	Md Sadre Alam <mdalam@qti.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>,
	dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: Re: [PATCH RFC v11 00/12] crypto/dmaengine: qce: introduce BAM
 locking and use DMA for register I/O
Message-ID: <aamsL4uh58Fv5een@linaro.org>
References: <20260302-qcom-qce-cmd-descr-v11-0-4bf1f5db4802@oss.qualcomm.com>
 <scr5qvxa7f7k22pms4c6k5gwiky7lhssrw6qryfngexlek44g2@rayinnnwqgbt>
 <aalwMwN3qMlzrql5@linaro.org>
 <CAMRc=MfjknN1AYF_NPLzR0YbdWuoET25D9o0zsvx56VN+u59HQ@mail.gmail.com>
 <aamIf8JethKzLW93@linaro.org>
 <CAMRc=Mf=NjCqf0eqmM800Q3MEUC48V_DZ3ts6+4=qMCtrbvzzQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMRc=Mf=NjCqf0eqmM800Q3MEUC48V_DZ3ts6+4=qMCtrbvzzQ@mail.gmail.com>

On Thu, Mar 05, 2026 at 02:54:02PM +0100, Bartosz Golaszewski wrote:
> On Thu, Mar 5, 2026 at 2:43 PM Stephan Gerhold
> <stephan.gerhold@linaro.org> wrote:
> >
> > On Thu, Mar 05, 2026 at 02:10:55PM +0100, Bartosz Golaszewski wrote:
> > > On Thu, Mar 5, 2026 at 1:00 PM Stephan Gerhold
> > > <stephan.gerhold@linaro.org> wrote:
> > > >
> > > > On Tue, Mar 03, 2026 at 06:13:56PM +0530, Manivannan Sadhasivam wrote:
> > > > > On Mon, Mar 02, 2026 at 04:57:13PM +0100, Bartosz Golaszewski wrote:
> > > > > > NOTE: Please note that even though this is version 11, I changed the
> > > > > > prefix to RFC as this is an entirely new approach resulting from
> > > > > > discussions under v9. I AM AWARE of the existing memory leaks in the
> > > > > > last patch of this series - I'm sending it because I want to first
> > > > > > discuss the approach and get a green light from Vinod as well as Mani
> > > > > > and Bjorn. Especially when it comes to communicating the address for the
> > > > > > dummy rights from the client to the BAM driver.
> > > > > > /NOTE
> > > > > >
> > > > > > Currently the QCE crypto driver accesses the crypto engine registers
> > > > > > directly via CPU. Trust Zone may perform crypto operations simultaneously
> > > > > > resulting in a race condition. To remedy that, let's introduce support
> > > > > > for BAM locking/unlocking to the driver. The BAM driver will now wrap
> > > > > > any existing issued descriptor chains with additional descriptors
> > > > > > performing the locking when the client starts the transaction
> > > > > > (dmaengine_issue_pending()). The client wanting to profit from locking
> > > > > > needs to switch to performing register I/O over DMA and communicate the
> > > > > > address to which to perform the dummy writes via a call to
> > > > > > dmaengine_slave_config().
> > > > > >
> > > > >
> > > > > Thanks for moving the LOCK/UNLOCK bits out of client to the BAM driver. It looks
> > > > > neat now. I understand the limitation that for LOCK/UNLOCK, BAM needs to perform
> > > > > a dummy write to an address in the client register space. So in this case, you
> > > > > can also use the previous metadata approach to pass the scratchpad register to
> > > > > the BAM driver from clients. The BAM driver can use this register to perform
> > > > > LOCK/UNLOCK.
> > > > >
> > > > > It may sound like I'm suggesting a part of your previous design, but it fits the
> > > > > design more cleanly IMO. The BAM performs LOCK/UNLOCK on its own, but it gets
> > > > > the scratchpad register address from the clients through the metadata once.
> > > > >
> > > > > It is very unfortunate that the IP doesn't accept '0' address for LOCK/UNLOCK or
> > > > > some of them cannot append LOCK/UNLOCK to the actual CMD descriptors passed from
> > > > > the clients. These would've made the code/design even more cleaner.
> > > > >
> > > >
> > > > I was staring at the downstream drivers for QCE (qce50.c?) [1] for a bit
> > > > and my impression is that they manage to get along without dummy writes.
> > > > It's a big mess, but it looks like they always have some commands
> > > > (depending on the crypto operation) that they are sending anyway and
> > > > they just assign the LOCK/UNLOCK flag to the command descriptor of that.
> > > >
> > > > It is similar for the second relevant user of the LOCK/UNLOCK flags, the
> > > > QPIC NAND driver (msm_qpic_nand.c in downstream [2], qcom_nandc.c in
> > > > mainline), it is assigned as part of the register programming sequence
> > > > instead of using a dummy write. In addition, the UNLOCK flag is
> > > > sometimes assigned to a READ command descriptor rather than a WRITE.
> > > >
> > > > @Bartosz: Can we get by without doing any dummy writes?
> > > > If not, would a dummy read perhaps be less intrusive than a dummy write?
> > > >
> > >
> > > The HPG says that the LOCK/UNLOCK flag *must* be set on a command
> > > descriptor, not a data descriptor. For a simple encryption we will
> > > typically have a data descriptor and a command descriptor with
> > > register writes. So we need a command descriptor in front of the data
> > > and - while we could technically set the UNLOCK bit on the subsequent
> > > command descriptor - it's unclear from the HPG whether it will unlock
> > > before or after processing the command descriptor with the UNLOCK bit
> > > set. Hence the additional command descriptor at the end.
> > >
> >
> > I won't pretend that I actually understand what the downstream QCE
> > driver is doing, but e.g. qce_ablk_cipher_req() in the qce50.c I linked
> > looks like they just put the command descriptor with all the register
> > writes first and then the data second (followed by another command
> > descriptor for cleanup/unlocking). Is it actually required to put the
> > data first?
> >
> 
> Well, now you're getting into the philosophical issue of imposing
> requirements on the client which seemed to be the main point of
> contention in earlier versions. If you start requiring the client to
> put the DMA operations in a certain order (and it's not based on any
> HW requirement but rather on how the DMA driver is implemented) then
> how is it better than having the client just drive the locking
> altogether like pre v11? We won't get away without at least some
> requirements - like the client doing register I/O over DMA or
> providing the scratchpad address - but I think just wrapping the
> existing queue with additional descriptors in a way transparent to
> consumers is better in this case. And as I said: the HPG doesn't
> explicitly say that it unlocks the pipe *after* the descriptor with
> the unlock bit is processed. Doesn't even hint at what real the
> ordering is.
> 

Yes, I think the transparent approach here is reasonable given the
design of the Linux DMA engine API. Since Mani commented "It is very
unfortunate that the IP doesn't [...]" I mainly wanted to point out that
this is probably because the main use cases the HW designers had in mind
don't strictly require use of a dummy descriptor. The comment about the
dummy descriptors might be more of a side note than an actual
recommendation to implement it that way (otherwise, the downstream
drivers would likely use the dummy descriptor approach as well).

> > > The HPG also only mentions a write command and says nothing about a
> > > read. In any case: that's the least of the problems as switching to
> > > read doesn't solve the issue of passing the address of the scratchpad
> > > register.
> >
> > True.
> >
> > >
> > > So while some of this *may* just work, I would prefer to stick to what
> > > documentation says *will* work. :)
> > >
> >
> > Well, the question is if there is always a dummy register that can be
> > safely written (without causing any side effects). This will be always
> > just based on experiments, since the concept of a dummy write doesn't
> > seem to exist downstream (and I assume the documentation doesn't suggest
> > a specific register to use either).
> >
> 
> You'd think so but the HPG actually does use the word "dummy" to
> describe the write operation with lock/unlock bits set. Though it does
> not recommend any particular register to do it.
> 

I guess the documentation I'm looking at (8.7.3.4 BAM operation in the
public APQ8016E TRM) might be an excerpt from some older version of the
BAM HPG. Is also has a note about "dummy" command descriptors:

  "NOTE: Pipe locking and unlocking should appear only in
   command-descriptor. In case a lock is required on a data descriptor
   this can be implemented by a dummy command descriptor with
   lock/unlock bit asserted preceding/following the data descriptor."

This one doesn't make any difference between READ and WRITE command
descriptors (and both are documented in the chapter).

Personally, I would prefer using a read over a write if possible. Unless
you can confirm that the register used for the dummy write is actually
read-only *and* write-ignore, writing to the register is essentially
undefined behavior. It will probably do the right thing on most
platforms, but there could also be one out there where writing to the
register triggers an error or potentially even silently ends up writing
into another register. Register logic can be fun in practice, commit
e9a48ea4d90b ("irqchip/qcom-pdc: Workaround hardware register bug on
X1E80100") [1] is a good example of that. :')

Thanks,
Stephan

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e9a48ea4d90be251e0d057d41665745caccb0351
