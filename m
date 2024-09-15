Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2AF22083;
	Sun, 15 Sep 2024 15:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726415189; cv=none; b=U1fBPJW1yleRbw5rpILyqFYyewLlWMnoP8w86AUNuzr1HsgoDcwaqRv+wJLbHQi+uF4A5cT9JOh24G/lb/am7T1gPK/sPNlWCJtIxIT9WOBy8/y9MHx9jLTyiuw08odV6hXAauTkoIfuWrPDtVXjlgbd+5X3fWc6xuSr0dhmg/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726415189; c=relaxed/simple;
	bh=wmh02ax7bxdvDqix/xpsk+FgCIWcDg2PRreRcb3NC7E=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fu6JqjQ7qY6hwDB5n04/m5+KXqjY8sdcp5MfFlBw1T0bwAPd76XCMy/F/itJ4JuDCbioA/1xBlboip8JM/L4h+2EfifnyIjdp1MW+M8B2ewFl7OVVGtOcVOtmjJQ/euBg51fQxl+1Di3pEHMPCk+6W+VvyXPI0Li3VNR3+M3uIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=wNEbaEm1; arc=none smtp.client-ip=198.47.19.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="wNEbaEm1"
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 48FFkB08037605;
	Sun, 15 Sep 2024 10:46:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1726415171;
	bh=iyoJ1y8gqyHmlggOH94jTqxkIyLVpJGw0gnc18XJljg=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=wNEbaEm1Jr8RgQ1fPkQbRGYigHtM25W3uXUpaDX5GW1f/JWiHFKhqiWBTSYkP/eRr
	 N1KmZ25rBEOLmDM41dJODbGnPu9PBOr4xUMp0ln81j1NPJjQcuPSC/djKEsez3ggUI
	 X9bq8XncU6qqSdWuwsRPxJRIjmjzwwyS5+5LRak8=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTP id 48FFkB81079857;
	Sun, 15 Sep 2024 10:46:11 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Sun, 15
 Sep 2024 10:46:10 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Sun, 15 Sep 2024 10:46:10 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 48FFkAxU072327;
	Sun, 15 Sep 2024 10:46:10 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Qianqiang Liu <qianqiang.liu@163.com>, <davem@davemloft.net>
CC: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: lib/mpi - Fix an "Uninitialized scalar
 variable" issue
In-Reply-To: <ZuTeivSjXN_uP-dZ@iZbp1asjb3cy8ks0srf007Z>
References: <20240913140741.5944-1-qianqiang.liu@163.com>
 <ZuTeivSjXN_uP-dZ@iZbp1asjb3cy8ks0srf007Z>
Date: Sun, 15 Sep 2024 21:16:09 +0530
Message-ID: <87y13sly2m.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Qianqiang Liu <qianqiang.liu@163.com> writes:

> On Fri, Sep 13, 2024 at 10:07:42PM +0800, Qianqiang Liu wrote:
>> The "err" variable may be returned without an initialized value.
>> 
>> Fixes: 8e3a67f2de87 ("crypto: lib/mpi - Add error checks to extension")
>> Signed-off-by: Qianqiang Liu <qianqiang.liu@163.com>
Thanks for the patch.

You can update the commit message and subject line to be more specific.

***
example
Subject: crypto: lib/mpi - Fix return of uninitailized variable err

If no error occurs, "err" variable will be returned with uninitialized
value, which is actually a success case scenario and return value should
have been zero.
***

This makes the need of entire fix more clear.
I think currently no body is checking return value of this function as
this is recent introduction or this would have failed.

Kamlesh
