From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.2 12.1/31] crypto: ccp: Define SEV userspace
 ioctl and command id
Date: Thu, 12 Oct 2017 15:27:52 +0200
Message-ID: <20171012132752.6qgkjyxuofwhvcto@pd.tnic>
References: <20171007010607.78088-2-brijesh.singh@amd.com>
 <20171011164605.115592-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171011164605.115592-1-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 11, 2017 at 11:46:05AM -0500, Brijesh Singh wrote:
> Add a include file which defines the ioctl and command id used for
> issuing SEV platform management specific commands.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Gary Hook <gary.hook@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Improvements-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Reviewed-by: Borislav Petkov <bp@suse.de>
> ---
> Make it as the first patch in the series (changed from 12.2/31 -> 12.1/31)
> 
> Changes since v5.1:
>  * add __packed improvement from Boris

...

> +/**
> + * struct sev_user_data_status - PLATFORM_STATUS command parameters
> + *
> + * @major: major API version
> + * @minor: minor API version
> + * @state: platform state
> + * @owner: self-owned or externally owned
> + * @config: platform config flags
> + * @build: firmware build id for API version
> + * @guest_count: number of active guests
> + */
> +struct sev_user_data_status {
> +	__u8 api_major;				/* Out */
> +	__u8 api_minor;				/* Out */
> +	__u8 state;				/* Out */
> +	__u8 owner;				/* Out */
> +	__u32 config;				/* Out */
> +	__u8 build;				/* Out */
> +	__u32 guest_count;			/* Out */
> +} __packed;
> +

After yesterday's discussion about the sev_data_status layout, that
struct is not needed anymore, right?

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
