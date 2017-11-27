From: James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH] X.509: reject invalid BIT STRING for subjectPublicKey
Date: Mon, 27 Nov 2017 19:21:04 +1100 (AEDT)
Message-ID: <alpine.LFD.2.20.1711271920510.2808@localhost>
References: <20171127071620.25724-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        linux-crypto@vger.kernel.org,
        Alexander Potapenko <glider@google.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171127071620.25724-1-ebiggers3@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, 26 Nov 2017, Eric Biggers wrote:

> Fixes: 42d5ec27f873 ("X.509: Add an ASN.1 decoder")
> Cc: <stable@vger.kernel.org> # v3.7+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/asymmetric_keys/x509_cert_parser.c | 2 ++
>  1 file changed, 2 insertions(+)


Reviewed-by: James Morris <james.l.morris@oracle.com>

-- 
James Morris
<james.l.morris@oracle.com>
