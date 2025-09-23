Received: from sender4-g3-154.zohomail360.com (sender4-g3-154.zohomail360.com [136.143.188.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D261A256E
	for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 00:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.154
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758674622; cv=pass; b=UmAZD7/qASOKcDiaTWHz1Jcf+BUrlF6CrWIvbqL5MCtVPUojMkkF2yzrBI49Zo5jPZX3gGoRd/THjKPiKQ1x1BLRxJZrdqVYC+fF/VoksD8vJHoes3cdhU+Z7OQKk4tMhDGLZBs73MHxO1SVmqAwy06bzhLsG84DQWpnuiGJ3LU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758674622; c=relaxed/simple;
	bh=N7dcmM4+A2ttGLwF8iSjZNC/0Oacl4JpSQCikPOxMDU=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type; b=t4X1VZQmRlBe36evIrYJj9lSl+TpXR38RCkogvmrZEkoEPHvNJ3hMyxQwoa76pk9RJM5HCzX+JcJwrJpeV2Qmqmp7dOLcc1JF3LiLaN2u77ZwTcd83EqUo8iSReWxiFI609SlAxMlyDOWNiopHtHNLRdbrNJMFHqrQsVTsXeqC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=maguitec.com.mx; spf=pass smtp.mailfrom=bounce-zem.maguitec.com.mx; dkim=pass (1024-bit key) header.d=maguitec.com.mx header.i=@maguitec.com.mx header.b=TpiP6B+9; arc=pass smtp.client-ip=136.143.188.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=maguitec.com.mx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce-zem.maguitec.com.mx
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=maguitec.com.mx header.i=@maguitec.com.mx header.b="TpiP6B+9"
ARC-Seal: i=1; a=rsa-sha256; t=1758674619; cv=none; 
	d=us.zohomail360.com; s=zohoarc; 
	b=puiwYmDuWpfAFe0YVPie4UYSP4EbQbulKAMWfTyBludfGkjjV79I8yFc73gB5w9bX1KR1EZ1USlkuRjE0R12TFghntQUKCZgVbsumBYMO7t3WgyR8HUxSBKFUw7NqOozgGeXL2rPZc5BH0lUrdRZztuvQPkcpdF95oT4wDFkTbA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=us.zohomail360.com; s=zohoarc; 
	t=1758674619; h=Content-Type:Content-Transfer-Encoding:Date:Date:From:From:MIME-Version:Message-ID:Reply-To:Reply-To:Subject:Subject:To:To:Message-Id:Cc; 
	bh=N7dcmM4+A2ttGLwF8iSjZNC/0Oacl4JpSQCikPOxMDU=; 
	b=o0tH5aHV6ZfaIQSxyZTEid3YXBiunD43sJ+HRblgz4QOsfAIwtKGECFPDg7Od08xEFK8QrRhIQPUIX7fdZIDB9oIUtAt91RIBlLrpIfjHMMx9Na/rWD0JlW6dgeykobjZw8lwqQKk0OXhSHZ4LvZkvJsB5uAFjmlYbKQAj1H3yI=
ARC-Authentication-Results: i=1; mx.us.zohomail360.com;
	dkim=pass  header.i=maguitec.com.mx;
	spf=pass  smtp.mailfrom=investorrelations+9a662a30-98d8-11f0-8217-5254007ea3ec_vt1@bounce-zem.maguitec.com.mx;
	dmarc=pass header.from=<investorrelations@maguitec.com.mx>
Received: by mx.zohomail.com with SMTPS id 1758671653244609.785444734124;
	Tue, 23 Sep 2025 16:54:13 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; b=TpiP6B+9EYg8S1Paq2SzphyNrOWTGPHVMw5dM4icbjaYKPBp4xGwVXxaZ+AQAM89+e9r6MGkg8cVS1BnoN43Wii8g6iAwoPx1fWcMvcjm1Uuozx5NTUvn12G65h5wUt4deuC7pqKVA/783BriSS5+0+berrD2U6aq68QGBbjbVM=; c=relaxed/relaxed; s=15205840; d=maguitec.com.mx; v=1; bh=N7dcmM4+A2ttGLwF8iSjZNC/0Oacl4JpSQCikPOxMDU=; h=date:from:reply-to:to:message-id:subject:mime-version:content-type:content-transfer-encoding:date:from:reply-to:to:message-id:subject;
Date: Tue, 23 Sep 2025 16:54:13 -0700 (PDT)
From: Al Sayyid Sultan <investorrelations@maguitec.com.mx>
Reply-To: investorrelations@alhaitham-investment.ae
To: linux-crypto@vger.kernel.org
Message-ID: <2d6f.1aedd99b146bc1ac.m1.9a662a30-98d8-11f0-8217-5254007ea3ec.19978ffc453@bounce-zem.maguitec.com.mx>
Subject: Thematic Funds Letter Of Intent
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
content-transfer-encoding-Orig: quoted-printable
content-type-Orig: text/plain;\r\n\tcharset="utf-8"
Original-Envelope-Id: 2d6f.1aedd99b146bc1ac.m1.9a662a30-98d8-11f0-8217-5254007ea3ec.19978ffc453
X-JID: 2d6f.1aedd99b146bc1ac.s1.9a662a30-98d8-11f0-8217-5254007ea3ec.19978ffc453
TM-MAIL-JID: 2d6f.1aedd99b146bc1ac.m1.9a662a30-98d8-11f0-8217-5254007ea3ec.19978ffc453
X-App-Message-ID: 2d6f.1aedd99b146bc1ac.m1.9a662a30-98d8-11f0-8217-5254007ea3ec.19978ffc453
X-Report-Abuse: <abuse+2d6f.1aedd99b146bc1ac.m1.9a662a30-98d8-11f0-8217-5254007ea3ec.19978ffc453@zeptomail.com>
X-ZohoMailClient: External

To: linux-crypto@vger.kernel.org
Date: 24-09-2025
Thematic Funds Letter Of Intent

It's a pleasure to connect with you

Having been referred to your investment by my team, we would be=20
honored to review your available investment projects for onward=20
referral to my principal investors who can allocate capital for=20
the financing of it.

kindly advise at your convenience

Best Regards,

Respectfully,
Al Sayyid Sultan Yarub Al Busaidi
Director
