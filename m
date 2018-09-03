From: Xiongwei Song <sxwjean@gmail.com>
Subject: Question about pe file verification
Date: Mon, 3 Sep 2018 16:31:56 +0800
Message-ID: <CAEVVKH9sq9oMX0hVen9sX+9GoG=4Y8v7RPMBD_iuZOe9Mgiw1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

Some code logic I don't understand about the function pefile_digest_pe_cont=
ents
 in the file crypto/asymmetric_keys/verify_pefile.c.
At the end of pefile_digest_pe_contents, please see the comment [sxw] below=
:

static int pefile_digest_pe_contents(const void *pebuf, unsigned int pelen,
                     struct pefile_context *ctx,
                     struct shash_desc *desc)
{
    unsigned *canon, tmp, loop, i, hashed_bytes;
    int ret;

    ......
=E3=80=80[sxw] I assume the image has signed by sbsign tool, there is a cer=
tificate
             at the end of image file.
    if (pelen > hashed_bytes) {
        tmp =3D hashed_bytes + ctx->certs_size;
        [sxw] The tmp value is the end of certificate.

        ret =3D crypto_shash_update(desc,
                      pebuf + hashed_bytes,
                      [sxw] The data address is the beginning of the
certificate.
                               Why do we need to hash the
certification data block?

                      pelen - tmp);
                      [sxw] However, the data length doesn't include
the certificate,
                               sometimes it's zero.

        if (ret < 0)
            return ret;
    }

    return 0;
}

Is that for a special consider or something else?

Regards,
Xiongwei
