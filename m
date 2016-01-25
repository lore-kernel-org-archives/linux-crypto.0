From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Don't require SpcSpOpusInfo in Authenticode pkcs7
 signatures
Date: Mon, 25 Jan 2016 22:00:58 +0800
Message-ID: <20160125140058.GA8379@gondor.apana.org.au>
References: <20160119010844.GA2919@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pjones@redhat.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, xlpang@redhat.com, vgoyal@redhat.com
To: Dave Young <dyoung@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160119010844.GA2919@dhcp-128-65.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Dave Young <dyoung@redhat.com> wrote:
>
>> So anyway, we should not be checking this field for presence or any
>> particular value: if the field exists, it should be at the right place,
>> but aside from that, as long as the hash matches the field is good.
>> 
>> Signed-off-by: Peter Jones <pjones@redhat.com>
>
> Tested-by: Dave Young <dyoung@redhat.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
