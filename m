Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724A633FE00
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 16:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779293339; cv=none; b=dEa7eguSKL9sxljbhKKWsRjEkXOG85tgml642g6gapSXi1GVn0ULQYbVvn5gUwn/2fAZFJfkc+litMkSE3sbnkITQlygqMRKoMQKJN1slqaQnA4eghu63tMOnGIFRIO1dVZvqNDYpcuNJbg5JXvDc8UkOq44V7QCoYGViSfCBKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779293339; c=relaxed/simple;
	bh=k59UMb8RUithwds8AxyeMKLGXUwQKUZoGOu6V0GVbEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CWQEoWUDSIENmZTNP1kykXDiBeLqNhPMEMp9oU960EWzNO26S10Y6ooOOv6GZf8x23ON1aCNxQtYi2uvj3yWTBSyv0pfvzbofP9nV8OzoNMw0pIIBnWPJVH0ZL3EMwnrDyB3W+ZVPS9UYM46rvPVuUDqEmsSUXHCutsZsUAneeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=URkhHbBY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="URkhHbBY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779293337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k59UMb8RUithwds8AxyeMKLGXUwQKUZoGOu6V0GVbEA=;
	b=URkhHbBYYDXBEk14apW7cRFbXmeRqbbFc1GOsOwOeKOw5mZSs8zdup+XkEkhtNq0WZbiUy
	rO7BpS9zf0xP0Eq7tChszBH2l6lji1lqzn73y/EnqDFWnMI+QTTE13n4UfWD9ZBiHsP7HV
	GzQ4qiVyaV1ZuqXeK2/0OFgRXWj2zLo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-526-geOa9zixMr2oS9yNhZ80xA-1; Wed,
 20 May 2026 12:08:53 -0400
X-MC-Unique: geOa9zixMr2oS9yNhZ80xA-1
X-Mimecast-MFC-AGG-ID: geOa9zixMr2oS9yNhZ80xA_1779293332
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CCE4218002E0;
	Wed, 20 May 2026 16:08:52 +0000 (UTC)
Received: from rules.brq.redhat.com (unknown [10.44.22.28])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E13FB1681;
	Wed, 20 May 2026 16:08:50 +0000 (UTC)
From: Vladislav Dronov <vdronov@redhat.com>
To: herbert@gondor.apana.org.au
Cc: akhilrajeev@nvidia.com,
	linux-crypto@vger.kernel.org,
	ptalbert@redhat.com,
	vdronov@redhat.com
Subject: Re: [PATCH] crypto: tegra - Return ENOMEM when input buffer allocation fails for ccm
Date: Wed, 20 May 2026 18:08:34 +0200
Message-ID: <20260520160834.29721-1-vdronov@redhat.com>
In-Reply-To: <ag0houiGk0cLZ9ls@gondor.apana.org.au>
References: <ag0houiGk0cLZ9ls@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Hi, Herbert,
Thank you for this fix! Please feel free to use my:

Reviewed-by: Vladislav Dronov <vdronov@redhat.com>

Best regards,
Vladislav Dronov

