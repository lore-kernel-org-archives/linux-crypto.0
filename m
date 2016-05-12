From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [RFC PATCH 8/8] KEYS: Implement PKCS#8 RSA Private Key parser
 [ver 3]
Date: Wed, 11 May 2016 17:09:48 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1605111707120.16566@mjmartin-mac01.local>
References: <20160511142152.4743.14414.stgit@warthog.procyon.org.uk> <20160511142252.4743.21903.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Cc: mathew.j.martineau@linux.intel.com, tadeusz.struk@intel.com,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, dwmw2@infradead.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20160511142252.4743.21903.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


On Wed, 11 May 2016, David Howells wrote:

> diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
> index 6516855bec18..417035a53e98 100644
> --- a/crypto/asymmetric_keys/Makefile
> +++ b/crypto/asymmetric_keys/Makefile
> @@ -34,6 +34,19 @@ clean-files	+= x509_akid-asn1.c x509_akid-asn1.h
> #
> # PKCS#7 message handling

Update to PKCS#8

> #
> +obj-$(CONFIG_PKCS8_PRIVATE_KEY_PARSER) += pkcs8_key_parser.o
> +pkcs8_key_parser-y := \
> +	pkcs8-asn1.o \
> +	pkcs8_parser.o
> +
> +$(obj)/pkcs8_parser.o: $(obj)/pkcs8-asn1.h
> +$(obj)/pkcs8-asn1.o: $(obj)/pkcs8-asn1.c $(obj)/pkcs8-asn1.h
> +
> +clean-files	+= pkcs8-asn1.c pkcs8-asn1.h


--
Mat Martineau
Intel OTC
