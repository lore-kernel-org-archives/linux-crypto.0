Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4A232ABF6
	for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 10:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761734627; cv=none; b=g2PWzdzJWS0Y/gn+gGX5zy49YQfNVjTJiSoSQ0Sn0F5wKw9eYnNG4UWcie2RTdNBKTrgOtaztmlv47VN43Rdnkq6n8tjq2/oGW57BDUB2++cwwpMqs8fcLmw/p5Hw8XkjwWvrtPIzITkT7E7dGYRixAjQihnBOBLuajRYjfsB/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761734627; c=relaxed/simple;
	bh=2oXoC0z5iX1QVctIx7be9YVECKd3qVj+JpFkjgooT/U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S3vZgdUtEuxOoBFN0lYYzXBylpKqozFK6w4+5pH+u60qIoanD77YBsM7AV6WSS5Bcen+4JSlPbBpL56ExkUgyy490AYAd5IscTGusxqgCPEmGFglHjXmO/yVh1GNuT4TUbHZlr4I+BZJrTv6jlvr55DhjNhcjoKgGaD3BTCDlnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U3DBtGnp; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U3DBtGnp"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4283be7df63so3455461f8f.1
        for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 03:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761734623; x=1762339423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HcoHF11ENhR3RrvSYHkD59wUi5AUsDEUQzjKh8Eb0i0=;
        b=U3DBtGnptuySBoVepvxKVciNuLzjA4f+SKmg7g0BuvrqxoloHXBwdNA4F5FVVCuN+m
         1OwQBQa5qhU0MeU+d76nXZSnLq7PB/YuyGIP1pJXy3iyX3gEx9MEnemTqtUjKhN49EN6
         DasjY9uQPLGuNmoirYLtOW/dJIQWucjbtN9CTAueSGTy0ndPvH1XxEYwVbSmXaGhu2Jw
         hHBpgJ5xPuM7HF21x+HBYQLeUR69iT/pj3Uo0Gmopkrz2U1yU9aYn0d7dQFocRu9MR6I
         oHNmYdf0QkWCSgXT3avcBe6Fu//CH4fk198qQ+d448V0TzqNfY/CZ/cX8jsIzAmOJl/o
         GptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761734623; x=1762339423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HcoHF11ENhR3RrvSYHkD59wUi5AUsDEUQzjKh8Eb0i0=;
        b=tc0bs5Rz6qOpZ0mDId4+8v68hj5mwxziwyxoXIrt9+BG7IGtdq8d1xi5WwG3GHMP2G
         cqTXQGZkiSFH5neQDUoZb9v3ll9YOvUS7bMaWt5drxL4nfddv8oRefkV9Ew7llMxs6sK
         CDxUQOd7FrcEEHCQ1XqwT6hOZSSpBZmLyQRWUB+ksaxCmPvjqKW4eoytYLb4yKNkIm/c
         PRIAP8kFIcx4xGQKq3m5TyLcXBdG7VXNIYdAgq0aCkAcnVQTeAq+MIDnzPuqKzPgxTzZ
         U3eXbbEWh0F2t0p/oaPx7wWbNNT6j7aixL8yyurRF9jv1JvTTbMWX95Nq3Ir7/DecM7W
         o1lw==
X-Forwarded-Encrypted: i=1; AJvYcCXyiZQ0NU9tu43ZT5p6YEMfjojFHSO0VHU/WKxyEWpI92/JCpwaadHqEmjqINkkxF4YChU+oiIdiS2B6to=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBaDjuPO77tUxol447vbqIlykXO8Lye14p9Rv854EtbhY03Dcb
	EoLn1vgTvW0DqElpbIOaWKaR687PH/p+AnrWZg+qFgMWWAwUS1XkdDwS
X-Gm-Gg: ASbGncu7ldZYRqXCxeuLFstXZW7Iu84mG7PdhsH5DrKsLWEoLXaBKjp6wpe7sXgRMuJ
	kaur+3DXxvi5GbnGMSpgN6UgR51SS6Iv1O1AJCMlfnUvoiBAe0/7A5ivMxI/Tyo0FM4/wQ0hX+I
	B734rYBAFtpr537JyUdP0Pkw+RfTc4i30ZjnOFXKxziFDN8NjthxGuPdYMg1XOHygHahAx+wkxA
	0LvmbPJuRQWRnrR4u6on6xO0wtXAtRx9o3K+JLaYPJe1WjbzvMXTOvrcdz8fVg7zhjG/D9++2os
	YbiBcs5sbQYbEtaaMZdM0cRF35tlr73/RjlJ02/hPOiQKuAf3doXJ1ZZcLxbETFlSlAS6ZLa1NJ
	hGAM2FXxJlZFJT2KKFvCAqV7h8bKEkcrf81PcxRhDcdz/bv0CvvlUEfkq7RSDmb40ktdcAth9FU
	cYTePX
X-Google-Smtp-Source: AGHT+IEmRI4Z/M00oieKbPxeIQldJKpH25/9dKm0itRMgfx3Wj6z2aQjBwr5JnK2lV2Z2mKsh3XAaQ==
X-Received: by 2002:a05:6000:240f:b0:427:a27:3a6c with SMTP id ffacd0b85a97d-429aefda93bmr1775484f8f.63.1761734623193;
        Wed, 29 Oct 2025 03:43:43 -0700 (PDT)
Received: from vasant-suse.suse.org ([81.95.8.245])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952df62dsm28137267f8f.45.2025.10.29.03.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 03:43:42 -0700 (PDT)
From: vsntk18@gmail.com
To: ashish.kalra@amd.com
Cc: Sairaj.ArunKodilkar@amd.com,
	Vasant.Hegde@amd.com,
	davem@davemloft.net,
	herbert@gondor.apana.org.au,
	iommu@lists.linux.dev,
	john.allen@amd.com,
	joro@8bytes.org,
	kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	michael.roth@amd.com,
	pbonzini@redhat.com,
	robin.murphy@arm.com,
	seanjc@google.com,
	suravee.suthikulpanit@amd.com,
	thomas.lendacky@amd.com,
	will@kernel.org
Subject: Re: [PATCH v6 3/4] crypto: ccp: Skip SEV and SNP INIT for kdump boot
Date: Wed, 29 Oct 2025 11:43:42 +0100
Message-Id: <20251029104342.47980-1-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <d884eff5f6180d8b8c6698a6168988118cf9cba1.1756157913.git.ashish.kalra@amd.com>
References: <d884eff5f6180d8b8c6698a6168988118cf9cba1.1756157913.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

   these changes seem to have been overwritten after
   459daec42ea0c("crypto: ccp - Cache SEV platform status and platform state")
   has been merged upstream.

   I can send a patch if that's not been done already. Please let me know.

Thanks,
Vasant

