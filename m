Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585723F5BDD
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 16:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294500; cv=none; b=tUbNRvy9HEstyDmGc+jLQV/LMbGFUkfb7ZEqkdQCnumUXDBNTkVN6z4GaFsDbNoEUX/szy7UAHFKbQjnYGtMoQsVxaUvTVWmDrkS08yGuDbBFvlvlOD8k6a1MCqjRCQITIG5dzsaRDhzMhN7IW+ToZtEjPVrAVaghO8rz4s1+Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294500; c=relaxed/simple;
	bh=wjOjfmpNnBtK34llA+nsjjZnEGozNitA7ndCPWOi43I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UA5R4rsHV7DDu9OmL9OnLRa7niy9SPnLH4keS9YRNm6og/MW4tIk6FZDpeCYuPN1c9jsAmVBNjK+1wFitjrwtqsKdE8C+ImG+KkcXl+I/0t4x/GAvwCbALW+HyUzaqIVPpSp7AQ3PfCnu9CkXtoh8F4+nWmIXzgtdzGANQT+wdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DFA8dHrF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DFA8dHrF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779294493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wjOjfmpNnBtK34llA+nsjjZnEGozNitA7ndCPWOi43I=;
	b=DFA8dHrFTNhphhmAsaSJ+3t4hjse72pqoMD1a2dI0JaQpZZQvUj/lClsxpsNKWhtbsnJN2
	hUFNs+iHiWcOCF3EqrOY5DM/yZBVnOD3y+l9tTa09dp+fJOReDaSI6GFp8GR6Nv33xmLZc
	EqDTXVenv/T7Nf0c9ncrwgRJfssx2Tw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-580-o5CluyECOW-EDzj7GP43xQ-1; Wed,
 20 May 2026 12:28:09 -0400
X-MC-Unique: o5CluyECOW-EDzj7GP43xQ-1
X-Mimecast-MFC-AGG-ID: o5CluyECOW-EDzj7GP43xQ_1779294489
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AFFE518005B8;
	Wed, 20 May 2026 16:28:08 +0000 (UTC)
Received: from rules.brq.redhat.com (unknown [10.44.22.28])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CE8B119560A2;
	Wed, 20 May 2026 16:28:06 +0000 (UTC)
From: Vladislav Dronov <vdronov@redhat.com>
To: herbert@gondor.apana.org.au
Cc: akhilrajeev@nvidia.com,
	linux-crypto@vger.kernel.org,
	ptalbert@redhat.com,
	vdronov@redhat.com
Subject: Re: [PATCH] crypto: tegra - Return ENOMEM when input buffer allocation fails for ccm
Date: Wed, 20 May 2026 18:28:01 +0200
Message-ID: <20260520162801.31189-1-vdronov@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi, Herbert,
I would also add the fixes: tag to your ENOMEM fix:

Fixes: 1e245948ca0c ("crypto: tegra - finalize crypto req on error")

Best regards,
Vladislav Dronov

