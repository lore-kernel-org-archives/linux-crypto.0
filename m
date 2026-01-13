Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA5736921B
	for <linux-crypto@vger.kernel.org>; Tue, 13 Jan 2026 06:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768287153; cv=none; b=hTd1J0kKffH2j3USGS6NbjjKpJaimdDgWT7gNe8TJUwY1tFAoeb/hs/vSCdJnOYEwOWwATtF3BuoGrLZ3m+M4Yta3vyBSLndqYeCsvVmTr1Z7I9EybkU3e/IhG5xQOMY84DqJf86Yq1C1sw/HS2ckQkjXyak6RGviGO0yo+V31Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768287153; c=relaxed/simple;
	bh=u5ndTcqmJIXcINAN9E+jQTe2o3wnYS5Yqo8Mpkx9bN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqJuU/8xk+uFbaZFPG2KF6EttJQDktk6KxoyUVL/VS1DEf0+VauGTHu/exF0rvMkO/7Mp7onIk6sM1wTUnUtbHIexcJJNtMZ1ExeSWiIoobSbHKeRi+XH5Q7rUZhj9Th2pV2ibdudw8V1YCqD93vgY0VE9gZD7OnpoEjc8a1cbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Tn4n9VbW; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Tn4n9VbW"
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2a137692691so47552155ad.0
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 22:52:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768287152; x=1768891952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u5ndTcqmJIXcINAN9E+jQTe2o3wnYS5Yqo8Mpkx9bN0=;
        b=YyI/0xrlOpokYxOTEn5vysmzQVcXYY9NwO6/fFUUfkUfd+60Xb+t9c9AzaGACOrIkV
         z6DCpLO+zthO9xul20ORKCByu3faD36tPDMIqq3TF6GhjHNrY3gi6l4lOePx1rkyvi5+
         7gyMF40dVQBTpbUsBDlVq4P4x9oHudDgjABEKLM3Nd5e8ibFdJ8DQnnevEyvBxU1wcsE
         D2kvg/yvDIog4MqMeJAFDhlDpNojw//igd4Y6fDvboLIhv2Vrf2bve+f+VJb04cKJ7bW
         OBVUui73mJJXl8hLJ/GPwjlgboLcxUPmxKJus1mNuOah1t1lZmtaGXxGY3pgVksSVXum
         92bQ==
X-Forwarded-Encrypted: i=1; AJvYcCX69GjbDBJy3rlofhTV9FnfrP6t+Yh6mV8jycFU5/0pSOgWX7+Z9cU+gQE+/+RCsFo0zgCZ8x3dclxDn9s=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywq03/Pt5Uev45cB/zaEqvKhuZbSHS8aDLHmnnvJFJ+qnNHtN9z
	EW/BmPH3TnVM6xAx+yNACSfnJ1sb+fnPN500Z8FlrAl+qzXIYEHSH+cY3ZeoM51uWFEn37fgmZl
	A3NANMwDCrEnEx0VoFBPOuRbeG6NsTt1mC/NGxC4VFXYhik2/feNIhm+QKoPfUjujDTBvrN5h18
	LA5qUKX8HjQgT6Jf3oXu2U0baqLGMOeJgxdlJ7ml8YKeBKW1kvhdY5E9HEkSi67+VGxRwqt8CP1
	T+e7EngtKCOU2416OQTLm2npd5kvpIYcrEITl4=
X-Gm-Gg: AY/fxX7+uw5DXd63Ew3+7nza4260rfD1CPBgJjh/K4P5FUR66jRszdEl37gybDKgcVb
	k/OJAv7EeZGaZ+PuuNBfurDVbCIbWv9Vh2foz7LH5xvUyP8RM9TwuSmoIliLca9/PMyQOGdTJZ4
	/Dv0/qaHvUozTdBzl61tDgw63QPCYzqI0zvrYVeMWYTS2dJ1rB/GRhUREIqAkyg9rCiib0e7nUR
	RjKW7gAjV4bbwS7SNpgTEVO5ndTi2UddAqO3/5RsyvoDStNLbjXIM6GoyAVq6xDQ7HFEdE3Lu/4
	q7D9v3XG/U8lROQQoT+QyCxY055p4iO7ZGtCUmv7Evge8fcxPFajI4nHPx6HG27aHAE02ONtTyD
	OTCHHR8A4q5Mp8+gcipHH3/UGmVZ0FHrt31O66fi2P5q2H4BkoxCfGMVcpxIWbrOXCW1ue7Pc/X
	tjAMg+Wa0myMiUUmiYFTkvpLvudHNqtv2cu/hy1lgHbl/Lf9kXk3f+X7O7OaoFog==
X-Google-Smtp-Source: AGHT+IGov52mlNsBiJNNCwslhxAom12QLz2nJIbfnql6UXIkOyajKqvcE8fohHs7BW5fHU2uHZqv9s6tC7tQ
X-Received: by 2002:a17:903:478d:b0:2a0:b438:fc15 with SMTP id d9443c01a7336-2a3ee468407mr188321695ad.11.1768287151577;
        Mon, 12 Jan 2026 22:52:31 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-2.dlp.protect.broadcom.com. [144.49.247.2])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2a3e3cc4aa8sm24793525ad.46.2026.01.12.22.52.31
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Jan 2026 22:52:31 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8905883e793so187844626d6.2
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 22:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768287150; x=1768891950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u5ndTcqmJIXcINAN9E+jQTe2o3wnYS5Yqo8Mpkx9bN0=;
        b=Tn4n9VbWWULoYK7mI6klgoy7MatYunAA4RZtF3ZBTwjzhYRLTQrzcOED1+bXkTWZmh
         iajro5fy2hYuRnNPCGw8cFF/GwHgFnwU860VajFQ6VH3XE0fDBrfjijp6rlmjOxkgqNG
         CSmWBuJi2thmzCCtL83fqQKvL7wi9HIgDJB2Q=
X-Forwarded-Encrypted: i=1; AJvYcCUviyDX1Ft5BrnnadqwEHCPN88/Nu6GV8Ma9QCfaGgqqIhcg1UUGA0u6xc732LdByc1uWYeEXnhU/VGqPg=@vger.kernel.org
X-Received: by 2002:a05:6214:3d0f:b0:88a:4694:5921 with SMTP id 6a1803df08f44-8908427529cmr245145866d6.37.1768287149887;
        Mon, 12 Jan 2026 22:52:29 -0800 (PST)
X-Received: by 2002:a05:6214:3d0f:b0:88a:4694:5921 with SMTP id 6a1803df08f44-8908427529cmr245145716d6.37.1768287149540;
        Mon, 12 Jan 2026 22:52:29 -0800 (PST)
Received: from dhcp-10-192-110-161.lvn.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770cc6edsm150749946d6.4.2026.01.12.22.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 22:52:29 -0800 (PST)
From: Vamsi Krishna Brahmajosyula <vamsi-krishna.brahmajosyula@broadcom.com>
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lucien.xin@gmail.com,
	steffen.klassert@secunet.com,
	keerthana.kalyanasundaram@broadcom.com,
	alexey.makhalov@broadcom.com,
	srinidhi.rao@broadcom.com,
	sunil-kumar.yadav@broadcom.com,
	ankit-aj.jain@broadcom.com
Subject: Re: [v2 PATCH] crypto: seqiv - Do not use req->iv after crypto_aead_encrypt
Date: Tue, 13 Jan 2026 00:13:23 -0600
Message-ID: <20260113061323.159523-1-vamsi-krishna.brahmajosyula@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <aUijI8zYq31rSY16@gondor.apana.org.au>
References: <aUijI8zYq31rSY16@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

> I intend to push this to Linus for 6.19.

Is this issue being considered as a CVE?

Thanks,
Vamsi
