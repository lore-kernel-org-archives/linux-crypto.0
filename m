Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487F833EB1D
	for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 11:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763033642; cv=none; b=FJHUxPf99RZo2qSMKFPJoQDkNuoigf3GmXbYluEihWlIRLIJ088apqQRXak2yL6u2xa1qXeNxQ2e1so6BeLz2UYq75n6fYreatZPlxHASPbK7jrIQn+1gkpTWCqGQOjgcAMjOH5w76lsGbW2+S5peFf5S95yS5paeSCANw5McRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763033642; c=relaxed/simple;
	bh=hZPNgdefE6AvRTEIIpd7l84uhOl5LSxQ4MAjyn1ko5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UDCtaWnKOlBNkmqcWHZlzO1KY5QbDqE9tcVDHtG2+pecnsNdivCFla+dkocpiKBAU7tWDiZiCUfQxwzHlFvueUU9KsU8GGE9BGiTuhUOveu6GWTNgFtt5qfXJNjd+wQvr9l7WgPROCsIemFZz7M5YnJNjOU/uqiIcTXFGZUyQl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xfYc8HJ3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KOXn7bwH; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xfYc8HJ3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KOXn7bwH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xfYc8HJ3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KOXn7bwH";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xfYc8HJ3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KOXn7bwH"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 77F5E1F791;
	Thu, 13 Nov 2025 11:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763033638;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZthUKqi7Vyr9Dbs6vpgzy1ZbXby823BXqYQY2rExP5c=;
	b=xfYc8HJ3uqMdilgQnEVnUmUl77L8T/0ulRch/+9/ZbtP/ZoVZfZM4fVVVkOjeHJ1MN7DqF
	26Yr6r3ypVbz0XfH+cCNw17DV/LmMVPwuHKETw/XDdPn/sCfTI8SIAHtEDRThgEcZMVld+
	VR7FfoW2Wc3tATHJYzB1ZT9ahcWJSVE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763033638;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZthUKqi7Vyr9Dbs6vpgzy1ZbXby823BXqYQY2rExP5c=;
	b=KOXn7bwHbPe8gRKhpJyzfcobV1Pr0ri5q6v5os8d6ImSZamE2kMXdiP88kQs15q/gmkiU5
	h5GJ1Gfry+YCUnDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763033638;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZthUKqi7Vyr9Dbs6vpgzy1ZbXby823BXqYQY2rExP5c=;
	b=xfYc8HJ3uqMdilgQnEVnUmUl77L8T/0ulRch/+9/ZbtP/ZoVZfZM4fVVVkOjeHJ1MN7DqF
	26Yr6r3ypVbz0XfH+cCNw17DV/LmMVPwuHKETw/XDdPn/sCfTI8SIAHtEDRThgEcZMVld+
	VR7FfoW2Wc3tATHJYzB1ZT9ahcWJSVE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763033638;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZthUKqi7Vyr9Dbs6vpgzy1ZbXby823BXqYQY2rExP5c=;
	b=KOXn7bwHbPe8gRKhpJyzfcobV1Pr0ri5q6v5os8d6ImSZamE2kMXdiP88kQs15q/gmkiU5
	h5GJ1Gfry+YCUnDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 68BF63EA61;
	Thu, 13 Nov 2025 11:33:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BARtGSbCFWnVcQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 13 Nov 2025 11:33:58 +0000
Date: Thu, 13 Nov 2025 12:33:53 +0100
From: David Sterba <dsterba@suse.cz>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: zstd - Remove unnecessary size_t cast
Message-ID: <20251113113353.GP13846@suse.cz>
Reply-To: dsterba@suse.cz
References: <20251108145707.258538-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251108145707.258538-2-thorsten.blum@linux.dev>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[7];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Sat, Nov 08, 2025 at 03:57:07PM +0100, Thorsten Blum wrote:
> Use max() instead of max_t() since zstd_cstream_workspace_bound() and
> zstd_dstream_workspace_bound() already return size_t and casting the
> values is unnecessary.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: David Sterba <dsterba@suse.com>
