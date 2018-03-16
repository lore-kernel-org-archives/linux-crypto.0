From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 00/12] Appended signatures support for IMA appraisal
Date: Fri, 16 Mar 2018 18:38:38 -0300
Message-ID: <87zi37og4h.fsf@morokweng.localdomain>
References: <20180316203837.10174-1-bauerman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "AKASHI\, Takahiro" <takahiro.akashi@linaro.org>
To: linux-integrity@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20180316203837.10174-1-bauerman@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com> writes:

> Now the modsig is only ignored if it references a signature that is not
> present in IMA's keyring (or if there's a parsing error, obviously). If the

The above should read "Now the modsig is only ignored if it references a
*key* that is not present in IMA's keyring".

Sorry, I only noticed the mistake after sending the emails.

--
Thiago Jung Bauermann
IBM Linux Technology Center
