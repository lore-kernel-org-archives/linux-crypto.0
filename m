Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A9C348C67
	for <linux-crypto@vger.kernel.org>; Mon,  5 Oct 2026 06:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791181695; cv=none; b=lBoUJatSPPQsezxQ/GKw22tsuYXyc3WsN3Ay5AluCF/NWqLUxZ1K+0KDkfaIfCEcm1wlHvPBC/owMcdu9bgNyMpbvmhL2ULjRm0HRrICSxLkW3AExl+6f4U/SKt3wHQeB9fBBL97aaNDp+Hq8iOdXAvnU+sDETaQS6Tywan5wgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791181695; c=relaxed/simple;
	bh=JNCrdJBnnAqL/jwpqgfdN+WnXKXvfeK1kyNTahqk8NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z18DEpY5yNGWLh2jPcCT/awNX/wcM9S5qMuLiNUeQaJhnZpSmmySXpsdIE3lB/lNzS/wcuEWVR/7PY7VJFDJ3M9ku94nEvQsFNLpyNNeo7HOlRF7TRjS1RJwpTT2w8iG3gvyqv6jnJV6Hfjadu2xUiVfNKH7oJJYD0kgqCPm70s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=RYF57lsy; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="RYF57lsy"
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id C7B533F301
	for <linux-crypto@vger.kernel.org>; Mon,  5 Oct 2026 06:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1791181690;
	bh=JNCrdJBnnAqL/jwpqgfdN+WnXKXvfeK1kyNTahqk8NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=RYF57lsyE8mjNcu8wAWA0J45gwNRG0uWjhp9TGW2mr0WeGA1xp4/DjCxQIw+wIVCf
	 +pKz8ug3WGybfyq3/S5pYTBCM/f0OGs5U/Y2JUEebeySrsrPpao/bD3y5BeIo4nu2p
	 Bsm5LzeXvs7KweELl1HA4zjpCXC5bUDGZzx8FBWqjI4JJJpN/axoLwe0/UtXs3Ugpm
	 bz4S+hBJFdEHFrl/G0MHWbpCe9x8ezzDSkWi3V5LV30g+9LxVbN+r3cnayCEhyxwyw
	 no41nx3DRJgBRxJx7WhFNXTrRdENH8aqCiUKe71zeHeidD78FxUuL3JMQqQ/RDY7g+
	 EQn7x+/WTTtvYkGduCqXbGYWZ9qcyXfxGCQ8qviZ7P88Sih6nfhMW7pjHw3UOsa0mk
	 7SsZIpEqTCJeC2+cEq01SkxLYgMXrCxgxmXIYbOXKR6FajGh46gHNCLcl8iTrTsV+3
	 BZUHrKvjR8PYlYszqB0GgWjEWL95rwT7lhhs007L2zlKBLT2WBUWwzl1gLBla4GaLc
	 P+oPpXvI2j06iGyZsHa0WXyZI+QvR3odkMwdVwfocorIezFim6ILjyK70WajcvXcE0
	 o4049JgFuafDXSugHjtEav+Fnb4TDPHVt8TavhKqsS9Bdl/Aj/97mDzsy3vjlPMfeG
	 tpT87oTYyIp3KWQb5UFtKkRw=
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-88a46301d92so1082658b3a.3
        for <linux-crypto@vger.kernel.org>; Sun, 04 Oct 2026 23:28:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791181689; x=1791786489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JNCrdJBnnAqL/jwpqgfdN+WnXKXvfeK1kyNTahqk8NM=;
        b=wgLMK3Ymg34IZ0kO1giaf6Q3UkkwCpomodx8qJK0/2t73KMTgbIvIz4Nlwvf6aMm8P
         ucpBQmh2KJXq3BGzNazGPLIQTI+GnxheHJOxVd9LS+gGFQgWbII5jaQz9fzg5UXvh4PR
         lU2Ysta46UXb5XO3YLBH/YCsiFRmAaaQhRcF578iZWhH1PVVnFNDdyrzj7E8tXNsXFY9
         0uJ6RSpfyt6cmrDQUkl89zM2tdKt1g5ONsT19+87fPagwZnfXYMU1aAXjmDe8j1in/Rd
         deFRI/MUFu7mRCaxAcgPPCB2IpKMCjixpnbB4cZLqT40/DJkjcHxJmFHc4xFcM0n8cyE
         xs3A==
X-Forwarded-Encrypted: i=1; AKwUvBxq3aFXLaFAp/n1KBkdhwvXBWgi4hGbv8iboF/LP2YWMf3ZKAQ9s3dw44cB6GIR6LjWOgKao+0tqVOZ9DY=@vger.kernel.org
X-Gm-Message-State: AFuF++kyjd3Pkqc0Opn5v6xM/5JI/esrA17DZLzHfPZf97di6SuYNfnr
	KnsZhP4hfmyt181AXcix4HTj/uVkQTwmdrrDbWAhxAkP9TKYOh4eVdP/VPmoCpUEThx+VYr+nVd
	S4le/KN7K6Cn/pa6GiwFK2AezD3J4bl0c9eQFU3JkL8cbD34ZusDwS+v70rt0uyyG3SwAWgKHp8
	TqfZKFRg==
X-Gm-Gg: AYBFou1tPNysKdEmMx5nbL8gwmdubMaeWcV0JtJZumvUpqvEQeqJaIZ5syK7QLcogst
	DbOjDp3PAUjyHhLEtJGvcfUcA+dk1ONa1VU1JQkCCWQPAM77zq6w4VLQLj6+1C7+jvxYlqJxzBc
	CmenaI6c8AOI/ZpRAaitezbgkhJef6/uzoLBYPaH/svyWqs+a/WyMdf7L3I7odZICsbCqkPK1iV
	VxtrGfdso41pxl/AoEdGISJYcqiCHZtD4QldwQjkmbDmsy2TIJ3dwBXD3+gBVtLBiAz7d71/eHF
	G1MqPFGdGTOwHL+I6C2bbOITX1vEALeUuRP4Nf7L2jYjjftq90ceLDgjdRFYWhuXmOYf8endTeH
	IWmyVMPyjnA==
X-Received: by 2002:a05:6a00:1253:b0:88b:9eca:94ff with SMTP id d2e1a72fcca58-88c600d2571mr5084090b3a.7.1791181688918;
        Sun, 04 Oct 2026 23:28:08 -0700 (PDT)
X-Received: by 2002:a05:6a00:1253:b0:88b:9eca:94ff with SMTP id d2e1a72fcca58-88c600d2571mr5084076b3a.7.1791181688535;
        Sun, 04 Oct 2026 23:28:08 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88b0bfc3da9sm3061771b3a.25.2026.10.04.23.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 23:28:07 -0700 (PDT)
From: Changwei Zou <changwei.zou@canonical.com>
To: martin.kepplinger-novakovic@ginzinger.com
Cc: changwei.zou@canonical.com,
	davem@davemloft.net,
	herbert@gondor.apana.org.au,
	sahil.malhotra@oss.nxp.com,
	ignat@linux.win,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	martink@posteo.de
Subject: Re: [PATCH v5] crypto: rsassa-pkcs1 - Avoid cacheline sharing with underlying driver
Date: Mon,  5 Oct 2026 17:28:01 +1100
Message-ID: <20261005062801.20336-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <e7b2e28eccfeb8c8dee87e9a8d782ccbd7d7da3d.camel@ginzinger.com>
References: <e7b2e28eccfeb8c8dee87e9a8d782ccbd7d7da3d.camel@ginzinger.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Martin,

Thanks a lot for your feedback.

Please refer to Herbert's review.

https://lore.kernel.org/linux-crypto/am2UMhd5CAhDiKBF@gondor.apana.org.au/

A new driver-level version (PATCH v2) is available at the following link.

https://lore.kernel.org/linux-crypto/20261004210200.290119-1-changwei.zou@canonical.com/

Kind regards,
Changwei

