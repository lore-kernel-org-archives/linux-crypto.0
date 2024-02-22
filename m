Received: from mail.vexlyvector.com (mail.vexlyvector.com [141.95.160.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B8118654
	for <linux-crypto@vger.kernel.org>; Thu, 22 Feb 2024 08:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.95.160.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708590938; cv=none; b=Rpl0NWcx0+28AqES+eZ3FGQkP8BYwT8YTRBxfnGkFLsUoCGUAzVoyrEq1buqMR53ntRLhybc3sy5ly15YqrYy00cfUeAsKMWoYAIQZD6FhEaObpCsi4IbkzaLGvRniVuvH4pPUKm72ipPFQeekRLoWi8HXjGEbVwhswrMobJEiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708590938; c=relaxed/simple;
	bh=waaYxUsyRtmB2zEBuWcqRuRHSoYd8sJFCtgHO/3AHKE=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=FGIn10MJSa6UNEXsQaX8W/ugK1RE/Eutyu3R425R/ovsgzyJh2SaDKvB2cqTKfkysVDhTq9kXrc+lDhortNvYRqEIYZ7EPQSbHnEDGzAQJFUrJVJeTQpTVL6KmU+OPXhjaSgv9h6kXK2i9cr0Di5mbWNMf18a1atNY4reUWag4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vexlyvector.com; spf=pass smtp.mailfrom=vexlyvector.com; dkim=pass (2048-bit key) header.d=vexlyvector.com header.i=@vexlyvector.com header.b=FkMGcuTl; arc=none smtp.client-ip=141.95.160.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vexlyvector.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vexlyvector.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vexlyvector.com header.i=@vexlyvector.com header.b="FkMGcuTl"
Received: by mail.vexlyvector.com (Postfix, from userid 1002)
	id EC626A2F83; Thu, 22 Feb 2024 08:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=vexlyvector.com;
	s=mail; t=1708590926;
	bh=waaYxUsyRtmB2zEBuWcqRuRHSoYd8sJFCtgHO/3AHKE=;
	h=Date:From:To:Subject:From;
	b=FkMGcuTlpV1cZ3QMe2MuCNlKbTiMhgK8RS2Yy9ofDTIoayBZflfTtvuc0gTl80Lrc
	 jt6Ye+DJqxRYudqUHu5v2p2BcMts5PcfT6VfD6fPHksSbvfOHlYCaqCyZx/oLgSbBV
	 uFIBJMQj23pilvNL5P+dltbJN5fxOhj13Wk29gqHqyb2aPyYbwOEzGc1GWCadf8DN9
	 JYtHraO8PbFWXzRktZx1Lm+JjHH8qjRvzEGoisKGB0TKJFyTgsoyquL67OQErHtNYV
	 fdT+AyGEMNKAxvBAkQjhfYCiUSOHp2jxYBVt5LsWJZmo9g5qlLBiHe65jrKAswpZoH
	 FGbrvP28xZn8A==
Received: by mail.vexlyvector.com for <linux-crypto@vger.kernel.org>; Thu, 22 Feb 2024 08:35:15 GMT
Message-ID: <20240222074500-0.1.c6.qhtb.0.g6ai838k2y@vexlyvector.com>
Date: Thu, 22 Feb 2024 08:35:15 GMT
From: "Ray Galt" <ray.galt@vexlyvector.com>
To: <linux-crypto@vger.kernel.org>
Subject: Meeting with the Development Team
X-Mailer: mail.vexlyvector.com
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I would like to reach out to the decision-maker in the IT environment wit=
hin your company.

We are a well-established digital agency in the European market. Our solu=
tions eliminate the need to build and maintain in-house IT and programmin=
g departments, hire interface designers, or employ user experience specia=
lists.

We take responsibility for IT functions while simultaneously reducing the=
 costs of maintenance. We provide support that ensures access to high-qua=
lity specialists and continuous maintenance of efficient hardware and sof=
tware infrastructure.

Companies that thrive are those that leverage market opportunities faster=
 than their competitors. Guided by this principle, we support gaining a c=
ompetitive advantage by providing comprehensive IT support.

May I present what we can do for you?


Best regards
Ray Galt
