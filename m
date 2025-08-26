Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9B1BA34;
	Tue, 26 Aug 2025 01:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756173576; cv=none; b=WaQfYisEcvkivoAJ8ltkVaCd4sCx2jmkdIU1DWQ5RwXI9M96WN6F5psPHLGUNWf9sa8ipPcS3i4PQOXInFJ+SgNKxbG+Ynq2z15X54K/ZY1uLGiHPoX3Eam9XAkIu7VTf8EeSImfgRlm3/dm7XT5NYcwcvzJeqdtmDUNNQeVkf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756173576; c=relaxed/simple;
	bh=SqO3wZQbbBOopTxvXqU6ZgBpmHVg5y7g3D6OZer+35A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QRgVoppTUzt0QeFqfXp6SdgWhF5OmgTljkfY/fEa5nPlfulpwJfPFmjfup3xZsUixDiFzhJQviNb+Vu/F8DeFG8480TpkxtXpfsrkSUal+VE/4cUoL+8eF4BU5ZTIFKD4tj8L9Y/SiiKJ7WumgF4SEuIVO6Uz3RZqaOWSmV0zUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ev96wI3S; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ev96wI3S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=puWFAU2qlBvgr3QmSSx5Fke86GDYpoZYyF/8m0lz5L8=; b=ev96wI3SB3uucmlzNBk0tU47ct
	cuOtckx0TwhL+nKPP+K4hXgYP0CgMIvFSl5qSHTM8saZR/Fjau75cj7Vzye0ohjLcimifnsv2hLd+
	7LFOVhMI203dqlj8nNiQHNHgM0WmUIGj1BNcn3PXntrsi2UkzIMgHbn/W3NMGYUKFhpaVh4kBo9aS
	IVZ5UjY/GwlyQuMkYY6I0HSH94XDmLXDSrQZOTl+E074X0uidI/tv3aNsSFj4GNZF2qHWzO8E3M5a
	6sHaCpBI6KudoH/ZRnq3KO6irb4T9e3wUTm+S/NZXbjshjQRIgU7VELAYYr+Dyd6ahR6ORe2Yh6ZA
	DFNUqrCQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uqiii-00HGdO-25;
	Tue, 26 Aug 2025 09:59:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 26 Aug 2025 09:59:29 +0800
Date: Tue, 26 Aug 2025 09:59:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: huangchenghai <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, qianweili@huawei.com,
	linwenkai6@hisilicon.com, wangzhou1@hisilicon.com,
	taoqi10@huawei.com
Subject: Re: [PATCH v2 0/3] crypto: hisilicon - add fallback function for
 hisilicon accelerater driver
Message-ID: <aK0VAaqSLUVgMpbJ@gondor.apana.org.au>
References: <20250818065714.1916898-1-huangchenghai2@huawei.com>
 <aKvoPwhKyoVz8Yta@gondor.apana.org.au>
 <8896482c-c447-45f1-a59c-998a13119ece@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8896482c-c447-45f1-a59c-998a13119ece@huawei.com>

On Mon, Aug 25, 2025 at 09:00:37PM +0800, huangchenghai wrote:
>
> We currently do not support sharing hardware queues between tfm
> objects. Our rationale is as follows:
> a) Queue multiplexing (allowing multiple tfms to share a queue)
> theoretically improves resource utilization. However, hardware
> resources are shared among all queues, and performance is also
> shared. Once the hardware reaches its physical limits, all new
> services can only queue up in the queue. Therefore, reuse will only
> make the queue longer, not increase processing speed, and instead
> increase business waiting latency. In cases of insufficient queues,
> it is better to directly fallback to software processing.
> 
> In benchmark tests, only 16 queues or tfms are needed to achieve
> full hardware bandwidth performance.
> 
> b) After a queue is initialized by a tfm, if a new tfm has a
> different algorithm from the original queue, it cannot share the
> queue. Queue reuse is limited by the type of tfm algorithm.

Sorry but this is not acceptable.  The number of tfms are meant
to be large.  If your driver isn't able to support that then it
should be just deleted.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
