From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v2][RESEND] X.509: unpack RSA signatureValue field from
 BIT STRING
Date: Sat, 2 Jun 2018 21:12:00 +0200
Message-ID: <80e95323-eb7f-6af3-ad05-f174c69fb948@maciej.szmigiero.name>
References: <04f372f3-bc26-c629-2269-0e5d258f9d8f@maciej.szmigiero.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <04f372f3-bc26-c629-2269-0e5d258f9d8f@maciej.szmigiero.name>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 19.05.2018 14:23, Maciej S. Szmigiero wrote:
> The signatureValue field of a X.509 certificate is encoded as a BIT STRING.
> For RSA signatures this BIT STRING is of so-called primitive subtype, which
> contains a u8 prefix indicating a count of unused bits in the encoding.
> 
> We have to strip this prefix from signature data, just as we already do for
> key data in x509_extract_key_data() function.
> 
> This wasn't noticed earlier because this prefix byte is zero for RSA key
> sizes divisible by 8. Since BIT STRING is a big-endian encoding adding zero
> prefixes has no bearing on its value.
> 
> The signature length, however was incorrect, which is a problem for RSA
> implementations that need it to be exactly correct (like AMD CCP).

Any progress here?
This simple patch has already been submitted 3 times in last 3+ months...
