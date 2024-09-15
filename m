Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3BD1E871;
	Sun, 15 Sep 2024 16:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726418758; cv=none; b=cJTTNpxuYlLqL02jiaYDN1F86rubhHvPUUa6orZqa/VbH8H8kpINEmtbloArA+O2KDvAJ/wZqr1I6Sj/5xg6NET5MVLMThNleVGmgSskxaUiYT00BxYbwFmrccCifNzBQplh54gi5rOOLEOv12H05k5edU+MHoJsnBxSew76544=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726418758; c=relaxed/simple;
	bh=wNvsE+FHplx0TJKOaVb5HVTO0pNDzAhpOGFZaVayf8c=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fgtydkPu9YlaRva0kfUDZWD5GdMSubL8/5RD0uzXI8PjztFrdJ8PqWzFBRJt6Syzp3gjC92g6MLUCl8A2mHJQK6FNNgAvda1cA6+dWr48kCeUPEU+Kwa5GKIe2cgtdPhVZKSrsmXAW4hByVFp5sAikCeHT9FGaRlIcLYhV+q/DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=hPtePnom; arc=none smtp.client-ip=198.47.23.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="hPtePnom"
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 48FGcFtn087256;
	Sun, 15 Sep 2024 11:38:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1726418295;
	bh=YC9jkCMqYPYmO1ZYs+V2nydzlxwMhfDrDK4gThjF2vA=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=hPtePnomG3CePB8siS+4KcuYCOcMPdtutL8M3c164gYawcwXzt6Ag9HAruUC3LlOL
	 Vcq5c35J0W0r75ZdmVhh2k54uDlqsDTsgvkJHFAjs0dCtZp4UvPAsd/vOkAynZwA3r
	 7MrSHyqsH7IfKVKk7a2oQVX6Sgiee4RvYnjAuuBo=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 48FGcF4b005574
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 15 Sep 2024 11:38:15 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Sun, 15
 Sep 2024 11:38:15 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Sun, 15 Sep 2024 11:38:15 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 48FGcEHF108287;
	Sun, 15 Sep 2024 11:38:14 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Qianqiang Liu <qianqiang.liu@163.com>, <davem@davemloft.net>
CC: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: lib/mpi - Fix an "Uninitialized scalar
 variable" issue
In-Reply-To: <87y13sly2m.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
References: <20240913140741.5944-1-qianqiang.liu@163.com>
 <ZuTeivSjXN_uP-dZ@iZbp1asjb3cy8ks0srf007Z>
 <87y13sly2m.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Date: Sun, 15 Sep 2024 22:08:14 +0530
Message-ID: <87tteglvnt.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Kamlesh Gurudasani <kamlesh@ti.com> writes:

> Qianqiang Liu <qianqiang.liu@163.com> writes:
>
>> On Fri, Sep 13, 2024 at 10:07:42PM +0800, Qianqiang Liu wrote:
>>> The "err" variable may be returned without an initialized value.
>>> 
>>> Fixes: 8e3a67f2de87 ("crypto: lib/mpi - Add error checks to extension")
>>> Signed-off-by: Qianqiang Liu <qianqiang.liu@163.com>
> Thanks for the patch.
>
> You can update the commit message and subject line to be more specific.
>
> ***
> example
> Subject: crypto: lib/mpi - Fix return of uninitailized variable err
>
> If no error occurs, "err" variable will be returned with uninitialized
> value, which is actually a success case scenario and return value should
> have been zero.
My bad when I looked in detail,

   	if (!vsize)
		wsize = 0;
if this condition is true, mpihelp_mul will never be called, leaving err
uninitialized, not sure if that is success case scenario or failure.

If that is success case scenario, this fix will do the work, if it is
failure case scenario, appropriate return value should also needed to be 
err.

In any case, the commit message that I have mentioned will not be
correct, so please scratch that.

Kamlesh
 
