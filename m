Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622C320300
	for <linux-crypto@vger.kernel.org>; Wed,  8 May 2024 11:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715167999; cv=none; b=Qwm3JdmMqKIb7f0Z+VBdPLE6hx2Ba2cxf0bpb3BlmsRg/AVo5Gs4ZOt/Fo7RwiIsmh9NBpucdSOpvdTU3ylyTuMYimLsHOv7MvfHahUFyNJewGEgXiPLQcEczjDUmh2mu3XFndPbC9j8CqkYHLkvhASN4o5LInJ/lJ8eOkidka0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715167999; c=relaxed/simple;
	bh=iaTZDUo7nQT+sKuso8urk75es+OAZYlLUc7u6cL5fEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BJOLPhXdZswMiq8hnkkD1x5x+Z4muyUrSIfCssjYAATEkPc1IdP1ZIgmJE258yoBIJ+9hko7X4f6/c11EV5g7a7NYOghWF7ttcyTCGaQHSLCmk8/aRsheT3/wsU5N1b4TJz4zBlVmnwKvFFarIC9I+5pbAceKNrmX+VZcfPM41I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=fail smtp.mailfrom=kernel.org; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.org
X-CSE-ConnectionGUID: VTwQN8gIS1yIB+UW1fyn9A==
X-CSE-MsgGUID: Ov2WELvHSuObehsoxY3Zyw==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="11182966"
X-IronPort-AV: E=Sophos;i="6.08,145,1712646000"; 
   d="scan'208";a="11182966"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 04:33:18 -0700
X-CSE-ConnectionGUID: c9zr2djUT5G7+obvVu7uqw==
X-CSE-MsgGUID: hDGEzBX1QImS9aopIUamkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,145,1712646000"; 
   d="scan'208";a="33329141"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 04:33:15 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.97)
	(envelope-from <andy@kernel.org>)
	id 1s4fXs-00000005Pea-2D2U;
	Wed, 08 May 2024 14:33:12 +0300
Date: Wed, 8 May 2024 14:33:12 +0300
From: Andy Shevchenko <andy@kernel.org>
To: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>,
	Arnd Bergmann <arnd@arndb.de>, soc@kernel.org, arm@kernel.org,
	Hans de Goede <hdegoede@redhat.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH v9 7/9] platform: cznic: turris-omnia-mcu: Add support
 for digital message signing via debugfs
Message-ID: <Zjti-FkUCAQzMmrQ@smile.fi.intel.com>
References: <20240508103118.23345-1-kabel@kernel.org>
 <20240508103118.23345-8-kabel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240508103118.23345-8-kabel@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Wed, May 08, 2024 at 12:31:16PM +0200, Marek Behún wrote:
> Add support for digital message signing with private key stored in the
> MCU. Boards with MKL MCUs have a NIST256p ECDSA private key created
> when manufactured. The private key is not readable from the MCU, but
> MCU allows for signing messages with it and retrieving the public key.
> 
> As described in a similar commit 50524d787de3 ("firmware:
> turris-mox-rwtm: support ECDSA signatures via debugfs"):
>   The optimal solution would be to register an akcipher provider via
>   kernel's crypto API, but crypto API does not yet support accessing
>   akcipher API from userspace (and probably won't for some time, see
>   https://www.spinics.net/lists/linux-crypto/msg38388.html).
> 
> Therefore we add support for accessing this signature generation
> mechanism via debugfs for now, so that userspace can access it.

...

> +static irqreturn_t omnia_msg_signed_irq_handler(int irq, void *dev_id)
> +{
> +	u8 reply[1 + OMNIA_MCU_CRYPTO_SIGNATURE_LEN];
> +	struct omnia_mcu *mcu = dev_id;
> +	int err;
> +
> +	err = omnia_cmd_read(mcu->client, OMNIA_CMD_CRYPTO_COLLECT_SIGNATURE,
> +			     reply, sizeof(reply));
> +	if (!err && reply[0] != OMNIA_MCU_CRYPTO_SIGNATURE_LEN)
> +		err = -EIO;
> +
> +	guard(mutex)(&mcu->sign_lock);
> +
> +	if (mcu->sign_state == SIGN_STATE_REQUESTED) {
> +		mcu->sign_err = err;
> +		if (!err)
> +			memcpy(mcu->signature, &reply[1],
> +			       OMNIA_MCU_CRYPTO_SIGNATURE_LEN);

> +		mcu->sign_state = SIGN_STATE_COLLECTED;

Even for an error case?

> +		complete(&mcu->msg_signed_completion);
> +	}
> +
> +	return IRQ_HANDLED;
> +}

...

> +	scoped_guard(mutex, &mcu->sign_lock)
> +		if (mcu->sign_state != SIGN_STATE_REQUESTED &&
> +		    mcu->sign_state != SIGN_STATE_COLLECTED)
> +			return -ENODATA;

{}

Don't you want interruptible mutex? In such case you might need to return
-ERESTARTSYS. OTOH, this is debugfs, we don't much care.

...

> +#define OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN	33

33? Hmm... does it mean (32 + 1)?

-- 
With Best Regards,
Andy Shevchenko


