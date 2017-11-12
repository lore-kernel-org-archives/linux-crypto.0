From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH v3] tpm: use struct tpm_chip for tpm_chip_find_get()
Date: Sun, 12 Nov 2017 10:53:35 +0530
Message-ID: <CANc+2y4si3YW5FXWEdKz0UM5c76MBmHWu4RBF7d2dew9i-Ut+Q@mail.gmail.com>
References: <20171026135453.24672-1-jarkko.sakkinen@linux.intel.com> <20171031200303.GB18578@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Peter Huewe <peterhuewe@gmx.de>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Safford <safford@us.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        "open list:INTEGRITY MEASUREMENT ARCHITECTURE (IMA)"
        <linux-security-module@vger.kernel.org>,
        "open list:KEYS-TRUSTED" <keyrings@vger.kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20171031200303.GB18578@ziepe.ca>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Did basic check on tpm rng patch, it works fine. As it depends on this
patch this should be working fine too.

Tested-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>

Regards,
PrasannaKumar
