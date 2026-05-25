Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7487533FE0A;
	Mon, 25 May 2026 05:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779687876; cv=none; b=Q5q2K7q+fbTp4GCFL9YeKKvL7oIyR64bXScq+FxDH40Qr89cyfw2pXlwelyTXI7UD3v54ozJZnww0lIWYTX8KygQtSwPZadZSIc15e5zjeEIl+6HBWc/6p8+Wwmk8VNktT/kN9Mv/jUqnKI3IaWeGHvAWsQ3b00P5ed7qwt40uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779687876; c=relaxed/simple;
	bh=NGxB4exXZORUe+wH1jisCbk0AZDvq6ZdVxbGUzb2pm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kr3YMeOAzMxWJEnUNV+0X67adZutq6XZMb9iOar9taYnLYubfJIOdewId6NfImMchN1cwzOzERU1gHkKxT08CdHoQskltXBJv34OVuc1KmYpoMdrhiQkUphHXkH9LhY/76toQBNv6ug1lhu4AWFR/ileN6wa8TjK3KacT8iCm+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ewB6xBhT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ewB6xBhT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27821F000E9;
	Mon, 25 May 2026 05:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779687873;
	bh=88Npyed2q+zi0Zs6GqF23CrwfxW6+LlJKTbPEDjtJhc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ewB6xBhTAHFPcHoYmoNAQKnR38BLOJinqd0yySKslCcdGz8CNS/0yi9YFnr6LBycA
	 UJCe9t1ePg8o3PI0+7pQ/XdYCKuXkmQTA5vaF8WtaYkrY69fvjgKULReJRxyLA3HY+
	 l54MOdYF0vbWVNe+kFHrV5OlYzdWRttUVPNOeniZqobLm42DToswtoTd+owx3SKwU7
	 cLXp50FkiUvsOLmkKPlE0+KyHWcRxB8852V0wuytVAYB9bp8gxKLpcFaa57JuasXSy
	 ONir9L5BYNlzEz0gFW4Yu1LTb7OmtR5RH8rpVJHS1PovMAUIDHo+PYGER/DHmjNQ7U
	 olQ3h7Er8szZg==
Date: Mon, 25 May 2026 11:14:20 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Udit Tiwari <quic_utiwari@quicinc.com>, 
	Md Sadre Alam <mdalam@qti.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Stephan Gerhold <stephan.gerhold@linaro.org>, Bjorn Andersson <andersson@kernel.org>, 
	Peter Ujfalusi <peter.ujfalusi@gmail.com>, Michal Simek <michal.simek@amd.com>, 
	Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@codeaurora.org>, 
	Neil Armstrong <neil.armstrong@linaro.org>, dmaengine@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, brgl@kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v18 00/14] crypto/dmaengine: qce: introduce BAM locking
 and use DMA for register I/O
Message-ID: <saciwzun44yw2ijprcg6s6hz76gj2lm4m66usurtksuv4si2cl@xncnyfrqvigf>
References: <20260522-qcom-qce-cmd-descr-v18-0-99103926bafc@oss.qualcomm.com>
 <20260524204921.GC110177@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260524204921.GC110177@quark>

On Sun, May 24, 2026 at 03:49:21PM -0500, Eric Biggers wrote:
> On Fri, May 22, 2026 at 03:39:53PM +0200, Bartosz Golaszewski wrote:
> > Currently the QCE crypto driver accesses the crypto engine registers
> > directly via CPU. Trust Zone may perform crypto operations simultaneously
> > resulting in a race condition.
> 
> So this driver is just critically broken currently?  Yet it's still not
> marked as BROKEN?
> 

It is currently broken on a subset of platforms supporting multi-EE, not all.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
