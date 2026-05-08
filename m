Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0C831AA94
	for <linux-crypto@vger.kernel.org>; Fri,  8 May 2026 18:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778263340; cv=none; b=BNbjMj5s4lk1BapOdveFjjRJx4t7Df7GWtT92YjPOT2z37b02FAnrABSymwv4piYFefjn34sw7e/7S4vaTG/9Q74jKWqy/Yu6mLq5kpj3zXNFjGl6GgrYH/3Y4S6fw/dUD502sTewIMryFGGvwVY/3TV+j0PbcCBiHSpbiCEu9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778263340; c=relaxed/simple;
	bh=HcJz6VMTkfApFdjleG7mQcukjTCAb0JMtV1GPbyQ3D0=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=kQ3x16X/PX2SJRD+nq0sRLW0h2k3HaEiXzKhP8z5OSbyTKIqiNHeJArEJDW83pn04n/HoQouSwLrlDIE+j5ldwWYu9XscBbZSY64a1Bl0lazDjvu8PaP9b8hMwGHuf3+bxoBKq05v9pQEmAFsW2d1OVbPVB7pqNmJ7KtojB8Aps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yjdrph8+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yjdrph8+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778263338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZGqgfA1J5FpUiR5+Nk8eHRPb/t1oc8uclHJVTxFrrAo=;
	b=Yjdrph8+5y4/q8N9fDXpl6jFjP6OJqrkcYOIWVAl5toy1HE4jmbZiD7PIyZO11CBmR4KFI
	tJl3DH+dav6USxKN20BfFR7lmvLBpec8E53StcshPwAnfKKAac/ulMnYnjCD38CKHN/z2u
	2aR1DgvKYZQ0sBnY3WBIXqGN/Dn0jyE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-617-P0XOWXJkNMKscSXIyy0kXg-1; Fri,
 08 May 2026 14:02:14 -0400
X-MC-Unique: P0XOWXJkNMKscSXIyy0kXg-1
X-Mimecast-MFC-AGG-ID: P0XOWXJkNMKscSXIyy0kXg_1778263332
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8EBDD18002C8;
	Fri,  8 May 2026 18:02:11 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.48.83])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3D43F1801A63;
	Fri,  8 May 2026 18:02:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260428024400.123337-3-ebiggers@kernel.org>
References: <20260428024400.123337-3-ebiggers@kernel.org> <20260428024400.123337-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
    linux-afs@lists.infradead.org,
    Marc Dionne <marc.dionne@auristor.com>, linux-crypto@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    "David S . Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH net-next 2/5] net/rxrpc: Use local FCrypt-PCBC implementation
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <286247.1778263325.1@warthog.procyon.org.uk>
Date: Fri, 08 May 2026 19:02:05 +0100
Message-ID: <286248.1778263325@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Eric Biggers <ebiggers@kernel.org> wrote:

> +	if (skb_linearize(skb) < 0)
> +		return -ENOMEM;

It seems skb_linearize() doesn't like being used in this fashion:

	kernel BUG at net/core/skbuff.c:2295!
	...
	RIP: 0010:pskb_expand_head+0x41/0x220
	 __pskb_pull_tail+0x5e/0x2f0
	 rxkad_verify_packet_2+0xa8/0x190
	 rxkad_verify_packet+0x12c/0x150
	 rxrpc_recvmsg_data+0x1b0/0x470
	 rxrpc_kernel_recv_data+0xa6/0x210
	 afs_extract_data+0x5e/0x180
	 yfs_deliver_fs_fetch_data64+0x10b/0x200
	 afs_deliver_to_call+0xea/0x440
	 afs_read_receive+0x8d/0x150
	 afs_fetch_data_async_rx+0x12/0x20
	 process_one_work+0x18e/0x2b0

which corresponds to this:

	BUG_ON(skb_shared(skb));

Presumably this is done because fcrypt_pcbc_decrypt() doesn't handle being
called on a split buffer.  I think this may require skb_copy() to be used
instead, but that would need to be handled in rxrpc_input_call_event().

I think rxkad_decrypt_response() should be okay because the encrypted data is
extracted into a buffer first before being decrypted.

David

