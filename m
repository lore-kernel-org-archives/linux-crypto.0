From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.1 12.7/31] crypto: ccp: Implement SEV_PEK_CSR
 ioctl command
Date: Fri, 13 Oct 2017 11:14:37 +0200
Message-ID: <20171013091437.izbdktceyam54v3q@pd.tnic>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-7-brijesh.singh@amd.com>
 <20171012195331.bdzwqzyrjc6fi5lj@pd.tnic>
 <d83b3e27-1195-817e-e976-36982e275588@amd.com>
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
In-Reply-To: <d83b3e27-1195-817e-e976-36982e275588@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 12, 2017 at 09:24:01PM -0500, Brijesh Singh wrote:
> I assume you mean performing the SEV state check before allocating the
> memory for the CSR blob, right ?

I mean, do those first:

        if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
                return -EFAULT;

        if (!input.address)
                return -EINVAL;

        /* allocate a physically contiguous buffer to store the CSR blob */
        if (!access_ok(VERIFY_WRITE, input.address, input.length) ||
            input.length > SEV_FW_BLOB_MAX_SIZE)
                return -EFAULT;


Because if you allocate the memory first and some of those checks fail,
you allocate in vain to free it immediately after. And you can save
yourself all that.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
