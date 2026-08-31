Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87EC3101A5
	for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2026 20:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788209280; cv=none; b=MY/8YZrvkcL/QxHUPHfNbMtZCAeBlX8cBBMSXAY3xMCFveZRNEi9xOr1iRHXtZkgUj+ELCL2At9QaLdmomue0kGl3IUgwhnJWAuEscPiyo6swoF7nkxqonLx3qiiaNHAjfEig9PxK03+AIaC/0wR0cSNpkDgD9tnTtvQ6RFzDws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788209280; c=relaxed/simple;
	bh=x0A0yYcEIp4UEd2rRguEMM1NflFS8AKy2GFpo950VOI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h2DMnHWIoTPzghM0A+BDQW7X0n3bCVPI5DkkhGzEsWDWulJ7+68vPnQdVgipN/920wZCi6o5Xr0m5X+dvtrzRgnK5aC1s86jP4jdbk9HtYt+Ew+ngc44xQXTPWyUKvf/P7EtX28AhFD94RQZ1VrTdhb1xvoTeyP0UXCa1RNqV70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--shansinha.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nYyoursz; arc=none smtp.client-ip=209.85.214.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--shansinha.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nYyoursz"
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2d54187d8b0so1796215ad.0
        for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2026 13:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788209278; x=1788814078; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KHpyNbElWOK3TcOkKmWPd2BY5WxDBRm0wkAaJH7Inkg=;
        b=nYyourszQj/m27eFoUr86f+Mkt32Ca48aNWhqnG6DvweVWwCeHdbSt4Jh5W7VLcbOS
         hudBWrdrHcUInjELnzuqVE1pF31qKNAaubBIpjR+zHqb0BpOXug4xRpMvi1LNQgzk/DZ
         h1CMcIVdx5iK11iSq0xQ42u9ZEdAYOb+qzfmFz9DPNfzbCofKOhQLtmXWQdGVjWU0UNw
         MtK00uFVxUG7Ihr30GjEG6uScWamnN1eu2K68CziiJ3Fk+qUdLeCKJ6Hu/LKsuwAExRj
         w4enG8L6fkkLVTdf7Zm0FWMhw4EtNOxaMnSQf7L3BfCM1m8Sf88ZovPruphrzPR2pa3g
         sOFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788209278; x=1788814078;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KHpyNbElWOK3TcOkKmWPd2BY5WxDBRm0wkAaJH7Inkg=;
        b=oAzTI9QRpMT44YqzjHkAwMjmRoTfUkziaaQfgHMb++Kouf9VKLg4/DT5EfpDkeIG8J
         PRzPRTNkETKIfqgIRVQVIA+NYwxIzduzVXEYRrkzd85zzCjJ4v31FfTlp/KrwFUm53rT
         F6DyIqQGYbRf6eupVRHNOhxhKJZEXqXH6np/gn+05iMeWM1zIMDz1LL1k63jSuvsbNMH
         D9UYQ2Sy6SEPGank3UoSUljTJ+SADG4cfNyeZ4itYvixq0C3EOJc9ISPuU0BGpfXK9vz
         tkh3HSblMtaNTXknAhXkm3n6GzoI1rGjRFHT8R0XAasMTP+T5hz1XwUpkW211kZLmBO5
         0VcA==
X-Forwarded-Encrypted: i=1; AKwUvBzwNusiWiN9EnP8E5wKObKZVgNEPT8lpHVBiB0rUcS2eRGCE48mB1CmLny3LrOT6/y/b0Bsg9TQZ9/7lGs=@vger.kernel.org
X-Gm-Message-State: AFuF++kIAANXjoe53E6aSvyEvrnod6jvjRnkpkeCQTU+d9pxQ4QyUsg+
	u/q5I5hKIvhcWjiLEJkBAktVHjRTDoJ3eWVlS+tfz7RPebHXf8CHOhBgfnvTDzaLN8CA7bG+PRk
	uzHaZ9r8liQ4OAFKsfQ==
X-Received: from pldv19.prod.google.com ([2002:a17:902:ca93:b0:2d8:fd05:fddb])
 (user=shansinha job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f791:b0:2d9:1dee:43db with SMTP id d9443c01a7336-2d91dee456dmr149239135ad.15.1788209277881;
 Mon, 31 Aug 2026 13:47:57 -0700 (PDT)
Date: Mon, 31 Aug 2026 20:47:57 +0000
In-Reply-To: <20260430160716.1120553-7-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260430160716.1120553-7-tycho@kernel.org>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260831204757.436751-1-shansinha@google.com>
Subject: Re: [PATCH 6/6] crypto/ccp: Implement SNP firmware live update
From: Shantanu Sinha <shansinha@google.com>
To: tycho@kernel.org
Cc: shansinha@google.com, jackyli@google.com, aik@amd.com, 
	ashish.kalra@amd.com, davem@davemloft.net, herbert@gondor.apana.org.au, 
	john.allen@amd.com, kim.phillips@amd.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, michael.roth@amd.com, nikunj@amd.com, 
	prsampat@amd.com, seanjc@google.com, thomas.lendacky@amd.com
Content-Type: text/plain; charset="UTF-8"

On Thu, Apr 30, 2026 at 10:07:16AM -0600, Tycho Andersen wrote:
> +static int sev_firmware_shutdown_if_sev_initialized(struct sev_device *sev)
> +{
> +	int rc, error;
> +	int sev_plat_state;
> +
> +	rc = sev_get_platform_state(&sev_plat_state, &error);
> +	if (rc) {
> +		if (error)
> +			rc = error;
> +		dev_dbg(sev->dev, "SEV get platform state failed %d\n", rc);
> +		return rc;
> +	}
> +
> +	switch (sev_plat_state) {
> +	case SEV_STATE_UNINIT:
> +		return 0;
> +	case SEV_STATE_INIT:
> +		error = 0;
> +		rc = __sev_platform_shutdown_locked(&error);
> +		if (rc) {
> +			if (error)
> +				rc = error;
> +			dev_err(sev->dev, "SEV platform shutdown failed %d\n", rc);
> +			return rc;
> +		}
> +
> +		sev_firmware_needs_reinit = true;
> +		return 0;

Tested this on Milan and hit a failure during SEV re-init after firmware update.

__sev_platform_shutdown_locked() sets the FW platform state to UNINIT, but
sev_es_tmr and sev_init_ex_buffer remain firmware-owned in the RMP. When the
new firmware comes up, SEV_CMD_INIT_EX rejects the stale page state and fails
with SEV_RET_INVALID_PAGE_STATE (0x1A).

Tearing down the buffers on shutdown fixes it for us:

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1905,6 +1905,20 @@ static int sev_firmware_shutdown_if_sev_initialized(struct sev_device *sev)
	}
 
+	if (sev_es_tmr) {
+		wbinvd_on_all_cpus();
+		__snp_free_firmware_pages(virt_to_page(sev_es_tmr),
+					  get_order(sev_es_tmr_size),
+					  true);
+		sev_es_tmr = NULL;
+	}
+
+	if (sev_init_ex_buffer) {
+		__snp_free_firmware_pages(virt_to_page(sev_init_ex_buffer),
+					  get_order(NV_LENGTH),
+					  true);
+		sev_init_ex_buffer = NULL;
+	}
+
	sev_firmware_needs_reinit = true;
	return 0;

(Could also pull this and the cleanup in __sev_firmware_shutdown() into a shared
helper. This logic is duplicated there.)

>	if (ret == FW_UPLOAD_ERR_NONE) {
>		error = 0;
> 
>		rc = sev_get_api_version();
>		if (rc) {
>			if (error)
>				rc = error;
>			dev_err(sev->dev, "SEV query api version failed %d\n", rc);
>		}
>	}
> 
> +	if (!dlfwex_wants_rollback)
> +		sev_firmware_reinit_if_shutdown(sev);

If rc == SEV_RET_HWSEV_RET_UNSAFE, psp_dead is true but dlfwex_wants_rollback
is false, so it still falls through to re-init. Even though it is
recommended that the host should be rebooted after HARDWARE_UNSAFE,
reboot tooling can lag and we may want some buffer. Plus the kernel shouldn't
be touching a dead PSP anyway. Checking !psp_dead is a simple safeguard against
extra churn while awaiting restart:

+	if (!dlfwex_wants_rollback && !psp_dead)
		sev_firmware_reinit_if_shutdown(sev);

I also moved the call to sev_firmware_reinit_if_shutdown() ahead of
sev_get_api_version() so sev->state is already restored to INIT before sev
status is queried. This is just to avoid unnecessary transient states.
Curious if that logic makes sense to you. Am I missing something that made
the original ordering strictly necessary?

Best,
Shantanu
