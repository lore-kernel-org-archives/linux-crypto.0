Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D637035C185
	for <linux-crypto@vger.kernel.org>; Fri, 28 Aug 2026 05:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787895501; cv=none; b=rapxTOxhaNim2raTcY/MWguorcub/Vdnyn4THYDdNL0hcamtI4uX2LM1YFdAfBNfgD7/11LNR5+z1sDJzzY+6Cu4ByyLdV23C29FlVHUGIeV+YHse5APo5ft/3ia2OewDBwjJai2wm6PdSih4ttZg31U5RmutT99CDMs5fbj7ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787895501; c=relaxed/simple;
	bh=ze4/KJ3EuAm6NIWKJY+q2AbsfJkY72VQHW9dSMtVRjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFIc+7XZemHGr2F7K5Nz2De2ixVuCvfuwBGxO1QDSi56xhMagGKKHTfqUFuujMf+JVIyHbwqD9Zqt78SypobaWSBGBdB8RnwGeMEy+waVetbKXklyUyaNdFhvOd4cLmmdOAIxCleyNFuqcGRQkCmJdvcIjxwQperxec6p/4seMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rMwzSt+V; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rMwzSt+V"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-853c401326eso445577b3a.2
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 22:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787895499; x=1788500299; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yOMy5UhVHi5zUg4dOHf2EhT83jF167GqUxIegg/QvOA=;
        b=rMwzSt+VhVNSMkX/YQ4dR+OJB0iEEiaQjqg30UnmniH5XnqShSMNiWdMakjtmLvgtv
         OfYZdUnLb4mefiN+PaDAjdA+q1I3Y/LLbc/+VU8v5/2wcMGAV1h1FShP/XQFadPV2U4m
         ZSMI79hqqYOXjp0CDElBc9dXq2t7n/mL6fwhySeAVfW+X52DhDnhOpDNGTaQVR+9Hndr
         k83cqAzDlcUEtUlw4KyV70wmx9/ElPn499J3Nbwste5kJLsnz4uSdhKA+iEtoVX8t0JP
         OTniwtLV3tg9+mA3NRiqT0enfrsnhjrTvjdipy6o8c/Es9pb2mnkixCcnOR06e+rj6SL
         Sgew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787895499; x=1788500299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yOMy5UhVHi5zUg4dOHf2EhT83jF167GqUxIegg/QvOA=;
        b=bi63rYl4Jp6XwLZakRKr8qdsSM3MUulVE2+77ax6f9jF3zouS8nD4IHIovhc6FE0jZ
         n9Y/LHRF3TiVLBPocP3Sfv7ikOfqfioKdt/HSFJoa9ViTNxvb/npTksCfb5NDwBjZKO4
         BtI06N8DVDve6KwOmLQqmFK23P9pn9uiMM2xwgsut9S8umuzNEXbY+rWOSh2zKWtr98P
         5p+pn3HQ3VCdwTyNbxRKdBSgSjAOcnrju40E5dxGi0mjJCuXEAL1ymv62csYFkPijR89
         RvblWG55jeqZxXbqscWLLbnsJ2KEqUMy6wTNHwq2i+VaJ8dV0gWZE8rwjMppm6GSPKk/
         xHlQ==
X-Forwarded-Encrypted: i=1; AHgh+RqXUa/7NuKdpwHWVyl1GWqYUp3DK6AGVUkB+Opta4onmlG8dP9UssTmgr1Ik1yXJZNpPu+WxgzsNhSg5eY=@vger.kernel.org
X-Gm-Message-State: AFuF++kCvuyN12xhML0+TQfoVkIUs3oP4435Mxti1hvjl6lfI9Hnut9p
	nswxwcfwk//j/2mCRpNVPQ3depTkfLo4NHJHQHt5utDrfw9q0oLxZ190
X-Gm-Gg: AR+sD10RhfuroA98OLQtaJXNwziky53CW9qOdgKw1vqFKbfXN4Buh8FDwhj22aGVHGj
	iesY+2WpPkFWaQLhdGytBDoz0v0BWVXd4sNS4EqKCqT03CVuLWmUYTRrmSEN4Q82VY6vUW7dbs7
	jwm0M0TgWeQKLwEORHfyTEpFQU27n5F1RaGU5BrKNblJtjB8nvlKqemNVFF/UB1lFCrC7xRELCo
	c2dnZLwE2iWCFcAQ64Sh0+1Hg5ET/HQDeLNkMtuSLCWHpPhjQo1JJc5jTjXvZORylkbM6mKMSef
	ZhIzl84fBIE2pK6MZwzDMXf+de8rRSzAc4ctAM24ZHDHoEIVT1EIQcL7WMhSVsGQavyS19/Zkr+
	Qc+QSCYkBsji61J9xiElUup7ZH5sh2a5GDWWeXJ/WimYbt4nzaeqeKYI5CnrOkBYBaiqlYzXjBv
	y1uh5vKYjX6dtrlUUKbUPqAkWURtshOE7TaEJSwgGSxNkMY0kGTKbAwdJe3BD60fUlSyFltjpsh
	S2T5hFAYcL7
X-Received: by 2002:a05:6a00:3316:b0:848:2ab3:ddeb with SMTP id d2e1a72fcca58-8562b19ef19mr10115832b3a.14.1787895498970;
        Thu, 27 Aug 2026 22:38:18 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-856a2ea6fbbsm219433b3a.38.2026.08.27.22.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 22:38:18 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: dhowells@redhat.com,
	lukas@wunner.de,
	ignat@linux.win,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] keys: reject descriptions that exceed the index length
Date: Fri, 28 Aug 2026 14:38:04 +0900
Message-ID: <20260828053805.1410721-1-4ncienth@gmail.com>
In-Reply-To: <apEWZUFe8NmwgPDb@kernel.org>
References: <20260824113004.3755053-1-4ncienth@gmail.com> <apEWZUFe8NmwgPDb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jarkko,

Thanks.  You are right that the commit message should have included the
observed runtime evidence.  I had tested the bug, but omitting that evidence
made the report unnecessarily hard to assess.  Sorry about that.

No, the exact command above does not crash in my test.  I ran it as uid 1000
with no capabilities on the vulnerable v6.12.105 kernel, and it returned
ENOPKG.  There are three relevant details:

  1. The in-tree X.509 parser does not support an Ed25519 public-key OID.

  2. keyctl passes "%:s" as a literal non-empty description.  It does not
     request a generated description in that argument position.  An empty
     string is needed; add_key() normalizes that to NULL.

  3. On my system, the default OpenSSL configuration adds a Subject Key
     Identifier.  x509_key_preparse() prefers the SKID over the raw serial, so
     that also keeps the generated description short.

I repeated the test with a supported RSA certificate, no SKID, the same
32766-byte positive serial and two-byte subject, and an empty keyctl
description.  The keyctl process recorded uid 1000 and zero inheritable,
permitted and effective capabilities, then hit:

  kernel BUG at security/keys/keyring.c:1308
  __key_link_begin
  __key_create_or_update
  key_create_or_update
  __do_sys_add_key
  Kernel panic - not syncing: Fatal exception

For comparison, the same RSA/no-SKID certificate with "%:s" as the explicit
description created the key normally and produced no splat.  An RSA
certificate generated with the default SKID also created the key normally,
even with an empty description.

The original source reproducer, which constructs the DER without a SKID,
already produced the registered BUG and panic on 3/3 fresh v6.12.105 KASAN
boots as uid 1000.  The 32765-byte-serial control returned EDQUOT without a
splat.  With the patch, the boundary returned EINVAL and the control continued
to return EDQUOT on 3/3 fresh boots.

I will send a v2 with this observed trace and the before/after results in the
commit message.  The code change is unchanged.  I can also provide the source
reproducer privately if useful.

Thanks,
Daehyeon
