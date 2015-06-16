From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v5 3/4] crypto: rsa: add a new rsa generic implementation
Date: Mon, 15 Jun 2015 18:49:15 -0700
Message-ID: <557F809B.3060001@intel.com>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1> <20150615201847.15697.55852.stgit@tstruk-mobl1> <3921303.7tkMvJ6vYE@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	keescook@chromium.org, jwboyer@redhat.com, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3921303.7tkMvJ6vYE@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 06/15/2015 04:23 PM, Stephan Mueller wrote:
>> +	/* In FIPS mode only allow key size minimum 2K */
>> > +	if (fips_enabled && (mpi_get_size(key->n) < 256)) {
> Considering my previous email, shouldn't that check rather be
> 
> if (fips_enabled &&
>     ((mpi_get_size(key->n) != 256) || (mpi_get_size(key->n) != 384))

I'm not familiar with the FIPS requirements. I checked the NIST recommendations witch states that
RSA: |n| >= 2048 is acceptable. If FIPS allows 2K and 3K only then we need to change it.
