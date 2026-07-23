Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89BC4766A0;
	Thu, 23 Jul 2026 17:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784827652; cv=none; b=H0FvqvWUri7oVkwK0yJ037O471RD7MveafhY7mokbDK9bNWvKvkaa56UnPMsBzV6URHXV7o5SZ/apTTLe/aF75BxkmzaEM3cQLjrR90hgmFMtXzL9kvDjG5jtcAhMi+yM75pmFjAHVCjjv7R/LZzEy9K8Ld+EslIEOS75lJvGEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784827652; c=relaxed/simple;
	bh=cN/67PWeksam/oDyavbJthKuFKx4B7ZQWgZRS+bBZu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YvkFec3bgSuMaeUfpParEttc9yN823UEl3jhlfkJPQwlgtaKMTVm5M8/1Li6QzgSTJLId1SJ4Q6LvygD9KE5FNyG0+W3fPwJWbw5xLf05OwlxLEXBQ14F28gLxSApzVItZKo5RnchuYUbHgofsgQpkf3XNahhfJur3KG5PqL84Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gac3z5Kb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gac3z5Kb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C631F000E9;
	Thu, 23 Jul 2026 17:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784827650;
	bh=y6hmrvX6/zADRHHfcMX+3cn85LWUnEyDle0EN1gIv1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gac3z5KbG41u/i25YuRaqpwAtHTcf5k/ZvCq1DY0njO4UCRju3KkpQGAATBL4LxWg
	 UZ+8QSxHYCjqs0cu0KekgrzuOmuM1qlPeXxwNx4U9TB0Z8BWyPK0XnCRIAs4b6AGw+
	 doJaBXXN19Dlj6fQdPHQLmyRUpRP5oXtVZ+kL8j1s6Kw4JtMjyjBYbvAlrQXBTltz4
	 dCBsXfhYdeTNSEDvCN7cgxe1mK4tXcmJFdm838K+SyboKhXKQGwLt4jrJACPCa3k7Z
	 EhlI2kTGQRMlY/kM/44oD9Glha91fJ5DWx1ZAiv6FYcaOG1l6uqQSBPRGHyF+NvQ61
	 BqpcXlQkglhyA==
Date: Thu, 23 Jul 2026 10:27:28 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Udit Tiwari <quic_utiwari@quicinc.com>,
	Md Sadre Alam <mdalam@qti.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>,
	Andy Gross <agross@codeaurora.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vignesh Raghavendra <vigneshr@ti.com>, dmaengine@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, brgl@kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v24 00/14] crypto/dmaengine: qce: introduce BAM locking
 and use DMA for register I/O
Message-ID: <20260723172728.GA93534@quark>
References: <20260723-qcom-qce-cmd-descr-v24-0-4f87bb4d9938@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723-qcom-qce-cmd-descr-v24-0-4f87bb4d9938@oss.qualcomm.com>

On Thu, Jul 23, 2026 at 07:09:06PM +0200, Bartosz Golaszewski wrote:
> Currently the QCE crypto driver accesses the crypto engine registers
> directly via CPU. Trust Zone may perform crypto operations simultaneously
> resulting in a race condition.

You've claimed elsewhere that this isn't actually a problem currently
(since the problem will be introduced by a future TrustZone software
update).  If true, shouldn't the cover letter and commit messages be
corrected accordingly?

However, what if someone runs a LTS kernel on a system that has this
TrustZone update?  None of these patches have Cc stable, so LTS kernels
won't get them.

Also, won't these changes further exacerbate the performance issues with
this driver?  This series adds a lot of additional overhead, for example
by replacing fast MMIO writes with DMA transactions using highly
fragmented scatterlists (see qce_write()).  There are also new dynamic
memory allocations, which can fail.  In addition, there can now be an
additional delay to wait for TrustZone to stop using the hardware.

> Tested with tcrypt.ko, kcapi and cryptsetup.

Did this include testing that this patch series solves the problem it
claims to -- synchronizing between Linux and TrustZone?

- Eric
