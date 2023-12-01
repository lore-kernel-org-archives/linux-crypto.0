Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9322184
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 02:12:25 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r90VQ-005hlD-Hr; Fri, 01 Dec 2023 18:12:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 01 Dec 2023 18:12:29 +0800
Date: Fri, 1 Dec 2023 18:12:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Damian Muszynski <damian.muszynski@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: Re: [PATCH] crypto: qat - add sysfs_added flag for ras
Message-ID: <ZWmxjQ9tUCYOzvPl@gondor.apana.org.au>
References: <20231121170046.8097-1-damian.muszynski@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231121170046.8097-1-damian.muszynski@intel.com>

On Tue, Nov 21, 2023 at 05:59:45PM +0100, Damian Muszynski wrote:
> The qat_ras sysfs attribute group is registered within the
> adf_dev_start() function, alongside other driver components.
> If any of the functions preceding the group registration fails,
> the adf_dev_start() function returns, and the caller, to undo the
> operation, invokes adf_dev_stop() followed by adf_dev_shutdown().
> However, the current flow lacks information about whether the
> registration of the qat_ras attribute group was successful or not.
> 
> In cases where this condition is encountered, an error similar to
> the following might be reported:
> 
>     4xxx 0000:6b:00.0: Starting device qat_dev0
>     4xxx 0000:6b:00.0: qat_dev0 started 9 acceleration engines
>     4xxx 0000:6b:00.0: Failed to send init message
>     4xxx 0000:6b:00.0: Failed to start device qat_dev0
>     sysfs group 'qat_ras' not found for kobject '0000:6b:00.0'
>     ...
>     sysfs_remove_groups+0x29/0x50
>     adf_sysfs_stop_ras+0x4b/0x80 [intel_qat]
>     adf_dev_stop+0x43/0x1d0 [intel_qat]
>     adf_dev_down+0x4b/0x150 [intel_qat]
>     ...
>     4xxx 0000:6b:00.0: qat_dev0 stopped 9 acceleration engines
>     4xxx 0000:6b:00.0: Resetting device qat_dev0
> 
> To prevent attempting to remove attributes from a group that has not
> been added yet, a flag named 'sysfs_added' is introduced. This flag
> is set to true upon the successful registration of the attribute group.
> 
> Fixes: 532d7f6bc458 ("crypto: qat - add error counters")
> Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_accel_devices.h    | 1 +
>  .../crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c   | 7 ++++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
