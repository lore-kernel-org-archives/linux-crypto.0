Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F57086323
	for <linux-crypto@vger.kernel.org>; Mon, 24 Nov 2025 19:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764011024; cv=none; b=CHCrqPTiZN+2hf7yygtnKAdA8kjXvtGdSNHx1nKk2Is0ZorH1svniwWj/ESQPT9NW7ivKYWeiEfJPpADk5b3CW2sPHYi0dme/Vl0HBDNkUxnB6YMcc7QAxN6ILbOJLXBPv6T5pxTfSAznbfuggsPcdsJwCBcFpC201z7RsMZrKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764011024; c=relaxed/simple;
	bh=Zxcm3gNJd0jkM9LAEYuI5gtP/2LeK187+Kz7Qp3lg7g=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=B59LOuxBnswmgsD8MggLBjiKzB3fFjxOiz8t25XyUlcqZXl+0TcX0XLBCiEjDUBjzIpXE2lZHdSUGcRduKxYdcgKV0/IyKj9Da1+lh4WcakBhBPdxBygxAeD7kjXlWCmy1zwLl5lS1nHk3qeNBT3nxEFkVVToLqMzSroaIlJ79A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IixigsSr; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IixigsSr"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4779cb0a33fso45655105e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 24 Nov 2025 11:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764011021; x=1764615821; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:date:cc:to:from
         :subject:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Zxcm3gNJd0jkM9LAEYuI5gtP/2LeK187+Kz7Qp3lg7g=;
        b=IixigsSraEwLjuEp6ow0LL+1Cra4iR5RDoioScaJZW9C8elOqLgDPdOuBgqZy4rDdn
         PXL6YIG/zjR6ty5J5hmlKGB4s3AzR4XsqOrpsuwX0JXaE+E8CvBAICk76KBf0EHlu9YV
         jasJJ4EDOpn+hO9JqBidHlrxqL9XDxHkqjqdp99TD+uNlWrRvmAxeNy+Y1TG1oq+80AS
         cpb2xjiHiDMoaRVW5EIoH2n6HaO1DW9R6rY82GvdDmPr8vhrb/A8Vz3aEY3TG3lDu6jy
         e5E8mcARMkU64lhlgZ3WpqzFZIm0qhYuhHYyxR/oiLAEcFh0bdPUrA07X96Yz/UMDuc0
         Q5ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764011021; x=1764615821;
        h=mime-version:user-agent:content-transfer-encoding:date:cc:to:from
         :subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Zxcm3gNJd0jkM9LAEYuI5gtP/2LeK187+Kz7Qp3lg7g=;
        b=igTS7T3owgs7HvJg4ol1y5SbEGNXK6t4ZLxPFTug4VFgSypJ98nkmByuxHerMJBcUS
         ni5jQHB+ItuUXveK8IH97tgF0htlhXBQ5XGzsRoqu0FI/qzJdNfS7nUay+E3YxERuKAh
         ZSzZfAeIqfFIqvlN4yDm/f0oYTtyis1Zw6oYN2oAX+1XdqeVbGxPXc7at3iM080tNWHI
         8nYgbKBe2OULK/Fkul7ruadiQipp9YggWOzyYQDvdsHrpdOkjdoL0oQAFKMlE+5SavAa
         gMNl+l7/wcnZ62R6+IOdH2yPqndzSn5U3rU56eomJpDs0PeHJ/7qbfYXJR+m2HYtMh1x
         t6Ng==
X-Gm-Message-State: AOJu0YzQ7HtWFZgoKsGrq7Un9GYLD9ppKu5TBWoYAUigVXF386hX2+uu
	bDOkJvb+PnywDAjSOFzPa0aR6zHMprXrKDj5V+jf1X5KwqlEh1yWnG/mwTEBeA==
X-Gm-Gg: ASbGncsIYNC3ofNpBuJoV5U15VtoUKLfZUq4mrAL0QduywY4xGjETE5knPExNpnJBxc
	7pOiZqxG0xN8TD55/gZOH3xDjavLC/xa9cTz+oXEgx8EdKWZ6KThwTpVyZE8NubKBo6p6NWaC15
	3K85UpWpZElx4jwuRQPNzkFxJaM9SXrzfHBVxoOMZnMqyWmIMZKOcjlFF2WVCcEJ14YtyY1JOu7
	cWD9Y5vWo05ZRHPGH/5GRHMZCUuzyNJgGp9YZJoIFmfySu+rrdqw5MtW9qpJyakfO5BeC7YQAjC
	N60nyOSpHjkSnHVViA+zwMjDO0T5T90XqJYzbxmniL/nVHLzaDzt7oQ2nFkgGmb2ptYyq74adoX
	yDhwhJ7m7scB76RBrNHX/juHEPVmWbpMwK2vWw49nYQutvvqEjfPJ0yoyYWq1/w+qKILZ9MB/Bd
	9cuCpG8ZjP+FN9LwkZRfveycCW6jCpRx9Vmg==
X-Google-Smtp-Source: AGHT+IGYLfLoYRrNuhgHIuLc0gBE3x7JrYm7zZUk64MOqkH1xaWYPuIC/hvgzxDAS0QTdrbFY1ZD9A==
X-Received: by 2002:a05:600c:45c9:b0:477:af07:dd1c with SMTP id 5b1f17b1804b1-477c0212123mr150189625e9.35.1764011020683;
        Mon, 24 Nov 2025 11:03:40 -0800 (PST)
Received: from vitor-nb.Home (bl19-170-125.dsl.telepac.pt. [2.80.170.125])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf36d1fasm202264565e9.7.2025.11.24.11.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:03:40 -0800 (PST)
Message-ID: <b017b6260075f7ba11c52e71bcc5cebe427e020f.camel@gmail.com>
Subject: CAAM RSA breaks cfg80211 certificate verification on iMX8QXP
From: Vitor Soares <ivitro@gmail.com>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com, 
 herbert@gondor.apana.org.au, john.ernberg@actia.se,
 meenakshi.aggarwal@nxp.com
Date: Mon, 24 Nov 2025 19:03:38 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

I=E2=80=99m currently investigating an issue on our Colibri iMX8QXP SoM run=
ning kernel
6.18-rc6 (also reproducible on v6.17), where cfg80211 fails to load the
compiled-in X.509 certificates used to verify the regulatory database signa=
ture.

During boot, I consistently see the following messages:
 cfg80211: Loading compiled-in X.509 certificates for regulatory database
 Problem loading in-kernel X.509 certificate (-22)
 Problem loading in-kernel X.509 certificate (-22)
 cfg80211: loaded regulatory.db is malformed or signature is missing/invali=
d

As part of the debugging process, I removed the CAAM crypto drivers and man=
ually
reloaded cfg80211. In this configuration, the certificates load correctly a=
nd
the regulatory database is validated with no errors.

With additional debugging enabled, I traced the failure to crypto_sig_verif=
y(),
which returns -22 (EINVAL).
At this stage, I=E2=80=99m trying to determine whether:
 - This is a known issue involving cfg80211 certificate validation when the=
 CAAM
hardware crypto engine is enabled on i.MX SoCs, or
 - CAAM may be returning unexpected values to the X.509 verification logic.

If anyone has encountered similar behavior or can suggest areas to
investigate=E2=80=94particularly around CAAM=E2=80=94I would greatly apprec=
iate your guidance.

Thanks in advance for any insights,
V=C3=ADtor Soares
