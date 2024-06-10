Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5911082D75;
	Mon, 10 Jun 2024 14:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718030062; cv=none; b=kQbaAeJBfOFEcxzcCZ0wsSqbaDqwbKkWOQn0J07+KZJBMOT0l6DaZv0ATU/3HuUJFs1jBFUk6x2nYMpRfdkDywQdYR9dxIDfClOk9c5DuTQcMU2u2bClxfUKYCxJL0cxsQIiYDBSbIYOjoWLYNMrNX7x2/rm3jgebpsjhr+QnTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718030062; c=relaxed/simple;
	bh=yIDvmjEUKxEiKRe55dQzVZEHPz85XspzzrpNaGz2DIM=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=NBXkDcFpWkeMm1yk98LQInjHWXtaM6CbcDrjyPsGfoxOuJwfKLDhV9f7fQcdrLZKDWnSJaGHYMnVr69goDQZVMywf3qTnh4VDlnWbqp1nMObC6ZCifkfd9wzOCikL7fIG/L/Q1zFpRvVGbO+GmXIfTAW1+81KQIGXlhtBS+ruKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=OlZYgA38; arc=none smtp.client-ip=198.47.19.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="OlZYgA38"
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 45AEXkc9001490;
	Mon, 10 Jun 2024 09:33:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1718030026;
	bh=yIDvmjEUKxEiKRe55dQzVZEHPz85XspzzrpNaGz2DIM=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=OlZYgA389TA/1Rv7kHMlJXFpOS9eaRVkSKZ8GJD+CWyAONDNSJrGDZ0XSvQUM93U+
	 pIFFMI3p8+zu9gKvdNsUWJPywdWiYJvH1tGpWCkm0R6NRChmZ8zCamDdo00LvFwf0I
	 c0LN78IOuJ7cBpUUU0AahXeVX3zava2nrvv2igAw=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 45AEXk2t011040
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 10 Jun 2024 09:33:46 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 10
 Jun 2024 09:33:45 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 10 Jun 2024 09:33:46 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 45AEXjU1075052;
	Mon, 10 Jun 2024 09:33:45 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: <herbert@gondor.apana.org.au>, <kristo@kernel.org>, <will@kernel.org>
CC: <akpm@linux-foundation.org>, <davem@davemloft.net>,
        <mcoquelin.stm32@gmail.com>, <alexandre.torgue@foss.st.com>,
        <robh@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <conor+dt@kernel.org>, <vigneshr@ti.com>, <catalin.marinas@arm.com>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 0/6] Add support for MCRC64 engine to calculate
 64-bit CRC in Full-CPU mode
In-Reply-To: <20240524-mcrc64-upstream-v3-0-24b94d8e8578@ti.com>
References: <20240524-mcrc64-upstream-v3-0-24b94d8e8578@ti.com>
Date: Mon, 10 Jun 2024 20:03:44 +0530
Message-ID: <87tti098af.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

<kamlesh@ti.com> writes:

> From: Kamlesh Gurudasani <kamlesh@ti.com>
>
> MCRC64 engine calculates 64-bit cyclic redundancy checks (CRC)
> according to the ISO 3309 standard.
>

Hi Herbert,

Could you please review this and let me know if any changes are needed
to get it merged.

Thanks,
Kamlesh
