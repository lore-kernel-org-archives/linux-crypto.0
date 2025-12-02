Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F84C3C17
	for <linux-crypto@vger.kernel.org>; Tue,  2 Dec 2025 08:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764664345; cv=none; b=OnBTCXN6ri8TdNiQwWY0Jxsp8RlgYp2rNpXqdQvkQzs1ATQYu/lwoLMDKcRPHt1GNB6jZr24N4Bwh32FimitwzigALhws3N2MLVPqBUe1aJhhkjI0l/gxwDVEQ3ijUzDazGROwKP5YuLC+i5DjVx+gV0/c30iUjDVmkkUzCqa8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764664345; c=relaxed/simple;
	bh=9jtbSUYB1F7B+WQCinwX1LvDrwGfU6ViN6VPDM86J0o=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=a/Csj3tppuLm8jzYw3CmQq6MfoDlqc3kN1Oimvok/dHgcbpkrinBzvrzWKoiqIQNH28PDXao89sQobboJDtYZEJ/R0cvZsVY7DyaNspaCJkYnKDoN6QMvB0sIPdXAYHaMNIQYra9Luw1uU7b58PFNjjxn2t9Y6rxhNjYXYRVx4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=r1a2bDAs; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r1a2bDAs"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47118259fd8so49492435e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 02 Dec 2025 00:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764664341; x=1765269141; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FsHqPTshFNHLEG20rETs0sf9qOuekVbz2zLD+bVQbvI=;
        b=r1a2bDAshVCYlv8ehtwCrw2lpN1Tml+aF/kghfRJDWIniGw2Oxant1V5tnz90Y9TzQ
         LQaiigQp5U8UNIZYeRL3RH+bIywm+sIg1VuAYcYnr346P+Evh40XT9Js5UwP1xIC2lm7
         5Po79vL42WfLt1ukAtBm7EwlZJIJW4euuJC34K1F9qX2clf3ud2BW3fhDAg63rBgP/ud
         55RUXmaiTVL95jpNp1yG8SBzLIEgwW05n+DVqLA9PfNeSagb3oo396xVRmLL2mfLndLR
         qo8M2pVriOFymX7pQ0/hBg+d++KNiuGD1zmQUORRDCOI3WaU+0/SIzxq0AkHs1Chhtf3
         BF9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764664341; x=1765269141;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FsHqPTshFNHLEG20rETs0sf9qOuekVbz2zLD+bVQbvI=;
        b=IhfVwXR6i09FqmDiDKwpG50qaxAMHC9u5GPdOvdjU9oNdhiZ9luD4A3USZv91joGYc
         cDql/m8DNOXJyv/5xoKDZUdIGZdr+AQ05eEAyyeG7GrhyFrflazK68gySNivYbowRwSs
         eMob4quPsQdqfNnVlaFbj9ghx43RbG2Y5lmeKitWbCz2ZrrHzK01BazKzjZ034JecxJn
         Odf2VW4vxiirTQfKkASmizZt4PzT15qJoFfMAnAZ6xA6QiT+LuBJSWXUXO+n2hrYr1W7
         VusM0yHt89k0pTHAjTExYkM3vNCarvcS4JX+ocjcURjKwxlQ6rj38dQGXb8ID9QXFvKL
         cUWQ==
X-Gm-Message-State: AOJu0Yyq41pURtY15CGFlc1sWJqLg7MP5gLQuqXHOnvUYBp0xGn5Xd2P
	c2ctSdpJk2usM7YdE9utvI5xJfiPjncRHs0le5jaWlwXBJ1qVFNlr8aS967SS4a19Mj1GhSU4SN
	nwuQ5
X-Gm-Gg: ASbGnctKh9tJRbrDOWBHr2iaqMiM/2w4bd70n5zACs1Ehp3ihfg0AcNNsFZ1+99sJ/C
	csk5RrdVMScmmCS7OdxIEcN/FpE0dR3icl4eX/OL1JjWdGfNOCCwbivnnknnlLoX9c34dJWN1Uh
	q/BovXWB1bo71ULae319mfF5kJfjUh9RYXgvma3UmfHqCcmBABizvw8FyuYsSZjVy5XYpu3rr+l
	/j3Vc/5nyFUIhf8V6YF8J2bPtShTgdUj20FQ71tXrLo9XJ6HvlCkg0Go+l0APca7SVoFXkceLUc
	fpNFs4VYdcwy4EzwGPQC0s2G44F4Aew2ZIWoxJw+Um88/5xas0yvDJQcpmE2XbqYEr+Y+TNCdI2
	J1SpXOWZIgz2UUsRaQ78Zs449CfMWCKyQsHHvBRN22abqEYWTBjco1fALo36nDBsh5T4b41wcmn
	qqrWPHhjfu3s28Vml1
X-Google-Smtp-Source: AGHT+IFz6H4UwMZ4YMU33cn7Zdwnqkjvpb4Evb2fMV3ozaEs0cNcvZixxMFCO2MLrS8PoApwkB+IcQ==
X-Received: by 2002:a05:6000:1a85:b0:42b:3e0a:64b8 with SMTP id ffacd0b85a97d-42e0f22c54amr30540657f8f.24.1764664340572;
        Tue, 02 Dec 2025 00:32:20 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-42e1c5d6133sm33747712f8f.16.2025.12.02.00.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 00:32:20 -0800 (PST)
Date: Tue, 2 Dec 2025 10:47:16 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: linux-crypto@vger.kernel.org
Subject: [bug report] crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)
Message-ID: <aS6ZhKHx-mZF3qRI@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Alexey Kardashevskiy,

Commit 3532f6154971 ("crypto/ccp: Implement SEV-TIO PCIe IDE
(phase1)") from Nov 21, 2025 (linux-next), leads to the following
Smatch static checker warning:

	drivers/crypto/ccp/sev-dev-tsm.c:266 dsm_create()
	error: we previously assumed 'pdev->bus' could be null (see line 264)

drivers/crypto/ccp/sev-dev-tsm.c
    261 static int dsm_create(struct tio_dsm *dsm)
    262 {
    263         struct pci_dev *pdev = dsm->tsm.base_tsm.pdev;
    264         u8 segment_id = pdev->bus ? pci_domain_nr(pdev->bus) : 0;
                                ^^^^^^^^^
This line assumes "pdev->bus" can be NULL.

    265         struct pci_dev *rootport = pcie_find_root_port(pdev);
--> 266         u16 device_id = pci_dev_id(pdev);
                                           ^^^^
Unchecked dereference.

    267         u16 root_port_id;
    268         u32 lnkcap = 0;
    269 
    270         if (pci_read_config_dword(rootport, pci_pcie_cap(rootport) + PCI_EXP_LNKCAP,
    271                                   &lnkcap))
    272                 return -ENODEV;
    273 
    274         root_port_id = FIELD_GET(PCI_EXP_LNKCAP_PN, lnkcap);
    275 
    276         return sev_tio_dev_create(&dsm->data, device_id, root_port_id, segment_id);
    277 }

regards,
dan carpenter
