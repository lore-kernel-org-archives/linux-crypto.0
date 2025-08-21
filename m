Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403B3393DE0
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 20:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755809340; cv=none; b=qrNaFiVqBqrRaaVYcyy2/1kQn54poehMQwNQ9POps//EVvuaiM9Ad/2idnNb4I23SYFdjCi4vrHs23NbuxFcmRpbIdgTp9hBMXELh1UhCcvCigwE9XWKd7BXbIc3YFx3lwDGdwRG3Kb923C1TUuA3Yb8WEPb/djwiKFpgJrnmTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755809340; c=relaxed/simple;
	bh=bRI3KkIZzLFNWxrS5bqoPA2S8kfGVDRrsTbB/8NRJU4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HcDSowGPfIoZ7ajen4O+7N7V94VFzgbDxEvZPHjIXwApwAfUBqUZVK2A3mn1xy6t1Ceg37Y0lNqe4F2DaUGm0D0Se8LwnldhrjvYDvTBJypazM/rIOpNrON5HNLhm6hv5f0M3XQyUax22vb7YZWdJD21vTcj8hU2PqrWzneCW2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V6w3LXVG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V6w3LXVG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755809338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=V1C+xtJjkdou4BkLOq+e3Vy5dXdG0NO7lu35hyMhmRo=;
	b=V6w3LXVGChRHb0ZsLa/Ne9ZZ6pylQkkwIs/Dkp9GLhhkHPAL9fmqZcgcwUEOoimRxMpKyd
	XGzfRqJHwqQhY9OG25gvlh5Uo9KrfRNJCZybE5Kl64cm+E5rdZhns7zbPvS5g4U7S3X5cI
	6Y+SJjKNpOmP/CY2zR2Il19eA4mDVW8=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-425-3-fgJMAWPQm5LxUHAhrhfw-1; Thu,
 21 Aug 2025 16:48:53 -0400
X-MC-Unique: 3-fgJMAWPQm5LxUHAhrhfw-1
X-Mimecast-MFC-AGG-ID: 3-fgJMAWPQm5LxUHAhrhfw_1755809332
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5517019560A0;
	Thu, 21 Aug 2025 20:48:51 +0000 (UTC)
Received: from my-developer-toolbox-latest.redhat.com (unknown [10.2.16.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 263201955F24;
	Thu, 21 Aug 2025 20:48:47 +0000 (UTC)
From: Chris Leech <cleech@redhat.com>
To: linux-nvme@lists.infradead.org,
	Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 0/2] nvme: fixup HKDF-Expand-Label implementation
Date: Thu, 21 Aug 2025 13:48:14 -0700
Message-ID: <20250821204816.2091293-1-cleech@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

As per RFC 8446 (TLS 1.3) the HKDF-Expand-Label function is using vectors
for the 'label' and 'context' field, but defines these vectors as a string
prefixed with the string length (in binary). The implementation in nvme
is missing the length prefix which was causing interoperability issues
with spec-conformant implementations.

This patchset adds a function 'hkdf_expand_label()' to correctly implement
the HKDF-Expand-Label functionality and modifies the nvme driver to utilize
this function instead of the open-coded implementation.

As usual, comments and reviews are welcome.

Changes from v1:
 - Moved hkdf_expand_label() from crypto/hkdf.c to nvme/common/auth.c.
   It's not really an RFC 5869 HKDF function, it's defined for TLS but
   currently only used by nvme in-kernel.
 - Fixed kdoc label_len -> labellen
 - Replaced "static const char []" with "const char *", it's just
   clearer and generates the same code with a string literal assignment.

(I've left the crypto emails on this version, mostly to make it known
that hkdf_expand_label() has been moved as Eric asked.)

Chris Leech (2):
  nvme-auth: add hkdf_expand_label()
  nvme-auth: use hkdf_expand_label()

 drivers/nvme/common/auth.c | 86 +++++++++++++++++++++++++++++---------
 1 file changed, 66 insertions(+), 20 deletions(-)

-- 
2.50.1

