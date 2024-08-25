Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A03148FE1;
	Sun, 25 Aug 2024 11:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724587137; cv=none; b=pHSUMSfcGpjSabGrw3cz4DI0myl/I1kFAG8lcKy2ch7qA5+QvHC/pvxOBhnzse3GnAbeWAGrS8aXbHxlXeTd/Uomklbd/OuXth53l2JmldFEy5rn+weNP27nh9m/7jVz3qmrVB2aC413Uf7Qu9azZwljF7fDc7u1ppz0ifNCfrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724587137; c=relaxed/simple;
	bh=L6Uhnbjvvray5xcFbxymO9o9ahD5bexKxm1cklyDUQo=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YF9QPaIVpAhBCZUXTmaGw18snmhJA41EIpzgfNEhmwfASz0+0skWrKnLceVzjLBb21ThIWQ9u7CLxmFVa/fEddHFUQ8Rsh+UnXqhRkQr4BlQMM2wzhDxP6AIy7m1Bys+F5DsKSIj80WR2NzOigSiMyTTQNbMfaejBUZKfgLAlYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=NcRO8GXu; arc=none smtp.client-ip=198.47.19.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="NcRO8GXu"
Received: from fllv0034.itg.ti.com ([10.64.40.246])
	by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 47PBrfGW103864;
	Sun, 25 Aug 2024 06:53:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1724586821;
	bh=L6Uhnbjvvray5xcFbxymO9o9ahD5bexKxm1cklyDUQo=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=NcRO8GXuXtpnZ6hgTfwkjxuE34ohgxhdwEV8+T2wBsBlsRVgmzxAZeOnJ8cwXnQku
	 6kYWcRNfWztFiMAWm/EltLTBxIjF6m9XAsh6n724/rUKb9v6rqa+Pbs0vbSBeZawR6
	 hqzX+nweVeQZLWxuuvxIcHk11j/Kdb6jSZCkYy6I=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
	by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 47PBrfMR019974
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 25 Aug 2024 06:53:41 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Sun, 25
 Aug 2024 06:53:40 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Sun, 25 Aug 2024 06:53:40 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 47PBrekA078295;
	Sun, 25 Aug 2024 06:53:40 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Ma Ke <make24@iscas.ac.cn>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <t-kristo@ti.com>, <j-keerthy@ti.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ma Ke
	<make24@iscas.ac.cn>, <stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: sa2ul - fix memory leak in sa_cra_init_aead()
In-Reply-To: <20240813074958.3988528-1-make24@iscas.ac.cn>
References: <20240813074958.3988528-1-make24@iscas.ac.cn>
Date: Sun, 25 Aug 2024 17:23:39 +0530
Message-ID: <87ttf8n7i4.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Ma Ke <make24@iscas.ac.cn> writes:

> Currently the resource allocated by crypto_alloc_shash() is not freed in
> case crypto_alloc_aead() fails, resulting in memory leak.
>
> Add crypto_free_shash() to fix it.
>
> Found by code review.
>
> Cc: stable@vger.kernel.org
> Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
> Signed-off-by: Ma Ke <make24@iscas.ac.cn>
LGTM.

Reviewed-by: Kamlesh Gurudasani <kamlesh@ti.com>


