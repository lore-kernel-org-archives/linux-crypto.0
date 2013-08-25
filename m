From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 07/18] asymmetric keys: explicitly add the leading zero
 byte to encoded message
Date: Sun, 25 Aug 2013 18:13:13 +0200
Message-ID: <20130825161313.GD5171@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-8-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
	opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Len Brown <len.brown@intel.com>,
	Josh Boyer <jwboyer@redhat.com>,
	Vojtech Pavlik <vojtech@suse.cz>,
	Matt Fleming <matt.fleming@intel.com>,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
	Rusty Russell <rusty@rustcorp.com.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
	Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
	"Lee, Chun-Yi" <jlee@suse.com>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1377169317-5959-8-git-send-email-jlee@suse.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu 2013-08-22 19:01:46, Lee, Chun-Yi wrote:
> Per PKCS1 spec, the EMSA-PKCS1-v1_5 encoded message is leading by 0x00 0x01 in
> its first 2 bytes. The leading zero byte is suppressed by MPI so we pass a
> pointer to the _preceding_ byte to RSA_verify() in original code, but it has
> risk for the byte is not zero because it's not in EM buffer's scope, neither
> RSA_verify() nor mpi_get_buffer() didn't take care the leading byte.
> 
> To avoid the risk, that's better we explicitly add the leading zero byte to EM
> for pass to RSA_verify(). This patch allocate a _EM buffer to capture the
> result from RSA_I2OSP(), then set the first byte to zero in EM and copy the
> remaining bytes from _EM.
> 
> Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>

> -	ret = RSA_verify(H, EM - 1, k, sig->digest_size,
> +	EM = kmalloc(k, GFP_KERNEL);
> +	memset(EM, 0, 1);
> +	memcpy(EM + 1, _EM, k-1);
> +	kfree(_EM);

Spot a crash waiting to happen.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
