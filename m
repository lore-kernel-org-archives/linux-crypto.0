Received: from cdmsr1.hinet.net (210-65-1-144.hinet-ip.hinet.net [210.65.1.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5751F3B87
	for <linux-crypto@vger.kernel.org>; Sat, 18 Oct 2025 10:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.65.1.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760783818; cv=none; b=Paxjnkojynx/XZ5nqpgRqRnOQAypCe7UNP9yUhOZ9051lDbTHksLK6Irqlly5qGKFKQLwRfvG1exO1WKN5bRPz0Ne1/bcbkQg4LsOx8qrL8AcGFhTBKRlST5utUGJqsk5sPmi2iTETjnxbd9qowJQFDxvKBeuGBPgKXrJhh+eI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760783818; c=relaxed/simple;
	bh=/FrixWeVQD6gOURqDnw6xTmA6RR6vmKwFH2Z6JW0QFc=;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type; b=iY2gmXu+A99RsVp1YGQRvKZZdloNW+MllQm2muvgfK7FdH8cTdF0/qeE1iAZrd19XV0oeyMI0S1fqjFr9fFGOFLQovwPPDnCfTXl4GX98OF8TCouiqy3f6CXi+a0O1Q1rYZZ3cTiXvKe4L5sO3S7xX7dtJtU2eGoUgxr9qSfXvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ms29.hinet.net; spf=pass smtp.mailfrom=ms29.hinet.net; dkim=pass (1024-bit key) header.d=ms29.hinet.net header.i=@ms29.hinet.net header.b=CXyGm+i8; arc=none smtp.client-ip=210.65.1.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ms29.hinet.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ms29.hinet.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ms29.hinet.net header.i=@ms29.hinet.net header.b="CXyGm+i8"
Received: from cmsr5.hinet.net ([10.199.216.84])
	by cdmsr1.hinet.net (8.15.2/8.15.2) with ESMTPS id 59IAaqoD867885
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO)
	for <linux-crypto@vger.kernel.org>; Sat, 18 Oct 2025 18:36:54 +0800
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=ms29.hinet.net;
	s=default; t=1760783814; bh=GJd5bPIIeUFuiEkKg/ODYFZJL2Q=;
	h=From:To:Subject:Date;
	b=CXyGm+i8v21I6S0a69QWhllK1hkmkOcEyRUqP/YBRnj8hyJUtcfh7QFh9za5djmP7
	 /wkC/2EiLNSCAqXNfDkkR6g0emRsibFPVOimAuRSWnDh38qi/dhkgsbdBO8nURqRXK
	 IXCpiUglQRdpHIUY3YBatOckFlEECYIo8ByRA6Fc=
Received: from [127.0.0.1] (220-133-162-194.hinet-ip.hinet.net [220.133.162.194])
	by cmsr5.hinet.net (8.15.2/8.15.2) with ESMTPS id 59IAU5HI286311
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO)
	for <linux-crypto@vger.kernel.org>; Sat, 18 Oct 2025 18:32:15 +0800
From: "Sales - iGTI 439" <Linux-crypto@ms29.hinet.net>
To: linux-crypto@vger.kernel.org
Reply-To: "Sales - iGTI." <sales@igti.space>
Subject: =?UTF-8?B?Rmlyc3QgT3JkZXIgQ29uZmlybWF0aW9uICYgTmV4dCBTdGVwcw==?=
Message-ID: <ba6558a5-dae7-80bf-83e9-58e86329a314@ms29.hinet.net>
Content-Transfer-Encoding: quoted-printable
Date: Sat, 18 Oct 2025 10:32:15 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-HiNet-Brightmail: Spam
X-CMAE-Score: 100
X-CMAE-Analysis: v=2.4 cv=cYdxrWDM c=0 sm=1 tr=0 ts=68f36cb0
	p=ggywIp0tIZrEgnU2bSAA:9 a=DT8yXBZZ6eQH9r+/YDjJ5A==:117 a=IkcTkHD0fZMA:10
	a=5KLPUuaC_9wA:10

Hi Linux-crypto,

I hope this message finds you well.

We are a diversified general trading company with multiple business streams=
 and affiliated sister companies. While our operations span various sectors=
, we currently have a strong focus on the resale of general machandise and =
services on several products to our partners and associates in the UAE and =
UK.

Having reviewed your website and product offerings, we are pleased to move =
forward with our first order. To proceed, we would like to align on the =
following key details:

-Minimum Order Quantity (MOQ)
-Delivery timelines
-Payment terms
-Potential for a long-term partnership

To facilitate this discussion and finalize next steps, we will be sharing a=
 Zoom meeting invitation shortly.

We look forward to your confirmation and the opportunity to build a =
mutually beneficial relationship.

Best regards,
Leo Viera
Purchasing Director
sales@igti.space
iGeneral Trading Co Ltd
igt.ae - igti.space
