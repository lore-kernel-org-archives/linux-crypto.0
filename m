Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1091B3A16A8;
	Tue, 18 Aug 2026 17:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787074134; cv=none; b=qmuFy5h+76CD9byn5+v6NV/1rupGRATg/J1zESE1JQZzas8FYkaPTKOkph0YSZDLtqsHHur5p9R5eYGHOM6yj8nRKxuTo9XUhyJrP1+MmhMCHrTYtacERRX7QS2qOu+wQlPOXMyzNXRrbiZ5kkZxw8eyC4b3FEKFGxuxtFoHKNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787074134; c=relaxed/simple;
	bh=aKjBOxJtOHKblwAzAWzMUqs1vCve5EaCbczrRaM6B/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ObarHDcunJvGMhpWIEKNRIdKHF07V9pjrUVpBl3dwwvoLFdFc7DK/GdWcxdN1qarAjNpvCEfDOlJTatIzpMVH1SC10hB8KGZQLOCgx8xlDES3KZMvtuq5NdFMh5ecdeVIdg/dSnVWUhUbHglVFe3UavyjZ83SFu3+HwzhJmexFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=REKqc2iY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="REKqc2iY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1501F000E9;
	Tue, 18 Aug 2026 17:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787074132;
	bh=AMvLvIwbvWaYzLcJbfayRyV/WoDk+sWkmCQsUDLN0n8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=REKqc2iY/htqJhgqKsL8pcaEqAhF7auDkGxai0FDSb6fO8y3KkGYBRJy61J1TO/R/
	 tAnSkgFglOjcrU1a+dCTUE0Ib+pUsccgBRrusylJ1olxB1bPsWnwqNudOH1T0ALLJn
	 HFJwJBEY6yrXYlS2ZHc1Ex7kitcNxsVArxhaMRUGDuFwpkMldd90E0Fiw4AwA/NUqb
	 2KB/9sdWA2i6HdFGzGF/3fmWARD8Ch8DdyFnINiYPm8JhAEJ4ziiI8nN9TDo/dbazX
	 wQWlXRUvcf1NdJIAObEMe5ACOWTWPtkFOhXWK6Tm6VGl3vjgwE1O0AB5IjzgcpO9px
	 74gyENQhlRBIw==
Date: Tue, 18 Aug 2026 10:28:50 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	xuwei5@huawei.com, prime.zeng@hisilicon.com, liulongfang@huawei.com,
	qianweili@huawei.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH] crypto: hisilicon/sec - remove SEC crypto block cipher
 accelerator
Message-ID: <20260818172850.GC2249@quark>
References: <20260818083132.1860726-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818083132.1860726-1-huangchenghai2@huawei.com>

On Tue, Aug 18, 2026 at 04:31:32PM +0800, Chenghai Huang wrote:
> The Hisilicon SEC crypto cipher accelerator has been superseded
> by the newer SEC2 driver (drivers/crypto/hisilicon/sec2/). SEC2
> provides wider algorithm coverage and is the maintained path forward,
> and users have migrated to it.
> 
> The legacy SEC driver has had no active users for some time, and its
> primary maintainer, Jonathan Cameron, has moved on from Huawei and
> is no longer in a position to maintain it. With thanks to Jonathan
> for his contributions to this driver over the years, and with no one
> left to keep it up to date, remove it from the tree.
> 
> This drops the legacy SEC driver together with all of its residual
> configuration, devicetree binding and board description references:
> 
>   - drivers/crypto/hisilicon/sec/
>   - CONFIG_CRYPTO_DEV_HISI_SEC Kconfig option
>   - sec/ entry from drivers/crypto/hisilicon/Makefile
>   - Documentation/devicetree/bindings/crypto/hisilicon,hip06-sec.yaml
>   - hisilicon,hip07-sec device nodes and their supporting mbigen_alg /
>     smmu_alg infrastructure from arch/arm64/boot/dts/hisilicon/hip07.dtsi
> 
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>

Acked-by: Eric Biggers <ebiggers@kernel.org>

You might also need an ack from a devicetree maintainer for dropping the
devicetree binding, though.  They sometimes like to keep the bindings
around even with no driver for some reason.

- Eric
