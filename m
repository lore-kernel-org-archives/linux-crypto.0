Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302E13033E8;
	Tue, 21 Apr 2026 23:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776813065; cv=none; b=uW3rcYT+//tDYVTwv+TG52l0MUHNRqeUin2RFHQn9qaWr4mGqNSwm0VCbXyFPdgZGShbK/YBKJvfdKqPXR3hJIqoe9I8lH0M0Wa+bODPSMN8ivmrHrQ6Lvn98F1YAM6Y2Gr0iRMfZ+o7VhoD3YdInCy3SbH6JhoNLoZHhDi3rnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776813065; c=relaxed/simple;
	bh=s8w6aRrTGIVZcZnott7hhbbp4pjV3SKo8FhHdlUnzbk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MA3VCjItaxowliCCvjp6xXDWAuBtMizG24J48ky6OdknTKNMbuaSsotLBRssLQx1BksPNuB+ga//kG5KsylRFbxeYAZxV8g6do4B4OT4tMimKVUTim3YVcbg9UBOvhCYpFoCSAc22iDRt+uME/DTANEIWgFz6rU3tvdE4gQvy24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NN3oK5G7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NN3oK5G7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792ABC2BCB0;
	Tue, 21 Apr 2026 23:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776813064;
	bh=s8w6aRrTGIVZcZnott7hhbbp4pjV3SKo8FhHdlUnzbk=;
	h=From:To:Cc:Subject:Date:From;
	b=NN3oK5G7Dl4QBpQKVqrBqlVI53huLV0mOqha+6VR6HyEUqCKBuEMpEjRsL4Y0zQVW
	 cgnzUWMmXGACWzp8BzEPGQ8aK2/Rap9JZ3/Z4fbivOaZbaHtoJ7/Yn+CqYS2zPrkaV
	 zE5x2TvfDZzvodMVlgBA3yiNOT+EQsET0jiD/c19OxYo0tEyA7Dz1unaLmTGTKYm8q
	 MTRKG/8oEEqpNYkm2v2MOnXHs8AnGhvrqgNRbobalHXlMwwKRICs2jR8rKDI0XGyVl
	 2+cAtCahpdEJFe5xoIpQGdfMIzmnQ6eC4RhS86qUAsswMqDIkOChyR43Vqpe0Np3A6
	 a5J1blk3rpCxQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-bluetooth@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 0/2] Bluetooth: Use AES-CMAC library API
Date: Tue, 21 Apr 2026 16:09:15 -0700
Message-ID: <20260421230917.7057-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series removes unnecessary kconfig selections from CONFIG_BT, then
converts net/bluetooth/smp.c to use the AES-CMAC library API (which was
introduced in 7.1) instead of the crypto_shash API.  This makes the code
simpler and more efficient.

This series is intended to be taken through the bluetooth tree and can
be applied for either 7.1 or 7.2, depending on maintainer preference.

These patches were originally sent as
https://lore.kernel.org/r/20260404200645.28902-1-ebiggers@kernel.org and
https://lore.kernel.org/r/20260218213501.136844-14-ebiggers@kernel.org/

Eric Biggers (2):
  Bluetooth: Remove unneeded crypto kconfig selections
  Bluetooth: SMP: Use AES-CMAC library API

 net/bluetooth/Kconfig |   6 +-
 net/bluetooth/smp.c   | 180 +++++++++++++++---------------------------
 2 files changed, 65 insertions(+), 121 deletions(-)


base-commit: d46dd0d88341e45f8e0226fdef5462f5270898fc
-- 
2.53.0

