Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525C03AA4FB
	for <linux-crypto@vger.kernel.org>; Fri, 27 Mar 2026 10:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774606082; cv=none; b=eFNc3G0Ld7QtWl6ACxtvzMIMo4d8IkrGJIKmP0BzqhjPbKRLKDh/zd8oTGkiHSVKraKoosuh0BS4WBdJ5NcpMXZ7ZPsJnW9gXmGqyq2tTG80PrMGZ1EBvYLzOdIsrmaeaBBY/j1iIHmsXVqv/mm6hFu0yppwD9ZS5Ufm0kRRbE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774606082; c=relaxed/simple;
	bh=trohYpCrH5P64yD8RCZbWUNyLjtN0S/H316Yx9jgcDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hvjkgBPTolRk4KOVqDiohCofAr8rYL/Ln2NcHSS9bdBzBsZgf6QRwNo1VvYZoTSn8sxBV+Nn4wJEHS/w58qnFOg8IORK1dFDoCBj/PvwfdfeQcC21Ib6WKCwi2eTxg8NDEtTbhlyMAGYnu/MOzc05pDDqjczSBItgTigUg4GV8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Q06Huj5L; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Q06Huj5L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=4mQ0vDncZfLC7sCTnVpYXmsY2LhtQB5ou7F3gxEW3zw=; 
	b=Q06Huj5LZ1VH6YbFRHq05e5YXznAVfld4vzLO40s33Cbi0IWgF1lH8BwddyCZD5VeMOjuLpEYVB
	OtohhRoIrnHClHwQW0PljLqG864j/6mhKfWEHP+Ib0MsR9v119M7owI+0Zi7/zCBMp/TGSrJM8osZ
	dRx7u/DqUiBByqgdSwBP4A05N45BqhTl6Il2yy0TZcOZpVlFp+evyFMjDwatgsauyXPgF6WnMada8
	7jHwC5tZJdGJ6emxbhpkk8Q3sFqpJcKhqB19oe+daTCTBTJ/G1iqI6Wtzn75Wlwl7kSDYSNC5VOjU
	Fitj2x0Ewefmbgv9ET02Rujo9CI+ejLfkSFA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w63hC-001bnl-2f;
	Fri, 27 Mar 2026 18:07:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Mar 2026 19:07:57 +0900
Date: Fri, 27 Mar 2026 19:07:57 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v2] crypto: qat - add anti-rollback support for GEN6
 devices
Message-ID: <acZW_SD6KbtYksIh@gondor.apana.org.au>
References: <20260319110331.248189-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319110331.248189-1-suman.kumar.chakraborty@intel.com>

On Thu, Mar 19, 2026 at 11:02:57AM +0000, Suman Kumar Chakraborty wrote:
> Anti-Rollback (ARB) is a QAT GEN6 hardware feature that prevents loading
> firmware with a Security Version Number (SVN) lower than an authorized
> minimum. This protects against downgrade attacks by ensuring that only
> firmware at or above a committed SVN can run on the acceleration device.
> 
> During firmware loading, the driver checks the SVN validation status via
> a hardware CSR. If the check reports a failure, firmware authentication
> is aborted. If it reports a retry status, the driver reissues the
> authentication command up to a maximum number of retries.
> 
> Extend the firmware admin interface with two new messages,
> ICP_QAT_FW_SVN_READ and ICP_QAT_FW_SVN_COMMIT, to query and commit the
> SVN, respectively. Integrate the SVN check into the firmware
> authentication path in qat_uclo.c so the driver can react to
> anti-rollback status during device bring-up.
> 
> Expose SVN information to userspace via a new sysfs attribute group,
> qat_svn, under the PCI device directory. The group provides read-only
> attributes for the active, enforced minimum, and permanent minimum SVN
> values, as well as a write-only commit attribute that allows a system
> administrator to commit the currently active SVN as the new authorized
> minimum.
> 
> This is based on earlier work by Ciunas Bennett.
> 
> Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
> v1->v2
> - Replaced "Secure" with "Security" in the required files as SVN
>   means Security version number.
> - Style changes in adf_anti_rb.h
> 
>  .../ABI/testing/sysfs-driver-qat_svn          | 114 +++++++++++++++
>  .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     |  16 +++
>  .../intel/qat/qat_6xxx/adf_6xxx_hw_data.h     |   6 +
>  drivers/crypto/intel/qat/qat_common/Makefile  |   2 +
>  .../intel/qat/qat_common/adf_accel_devices.h  |   2 +
>  .../crypto/intel/qat/qat_common/adf_admin.c   |  70 +++++++++
>  .../crypto/intel/qat/qat_common/adf_admin.h   |   2 +
>  .../crypto/intel/qat/qat_common/adf_anti_rb.c |  66 +++++++++
>  .../crypto/intel/qat/qat_common/adf_anti_rb.h |  37 +++++
>  .../crypto/intel/qat/qat_common/adf_init.c    |   3 +
>  .../intel/qat/qat_common/adf_sysfs_anti_rb.c  | 133 ++++++++++++++++++
>  .../intel/qat/qat_common/adf_sysfs_anti_rb.h  |  11 ++
>  .../qat/qat_common/icp_qat_fw_init_admin.h    |  15 +-
>  .../crypto/intel/qat/qat_common/qat_uclo.c    |  25 +++-
>  14 files changed, 497 insertions(+), 5 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-qat_svn
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_anti_rb.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_anti_rb.h
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_anti_rb.c
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_anti_rb.h

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
