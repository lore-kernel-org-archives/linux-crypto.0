From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 01/10] powerpc: export of_get_ibm_chip_id function
Date: Thu,  7 May 2015 13:49:12 -0400
Message-ID: <1431020961-22285-2-git-send-email-ddstreet@ieee.org>
References: <1431020961-22285-1-git-send-email-ddstreet@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
 Robert Jennings <rob@pochix.net>, linux-crypto@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, Seth Jennings <sjennings@variantweb.net>,
 Dan Streetman <ddstreet@ieee.org>, Anton Blanchard <anton@samba.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Paul Mackerras <paulus@samba.org>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1431020961-22285-1-git-send-email-ddstreet@ieee.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

RXhwb3J0IHRoZSBvZl9nZXRfaWJtX2NoaXBfaWQoKSBmdW5jdGlvbi4gIFRoaXMgd2lsbCBiZSB1
c2VkIGJ5IHRoZQpQb3dlck5WIE5YLTg0MiBkcml2ZXIuCgpTaWduZWQtb2ZmLWJ5OiBEYW4gU3Ry
ZWV0bWFuIDxkZHN0cmVldEBpZWVlLm9yZz4KLS0tCiBhcmNoL3Bvd2VycGMva2VybmVsL3Byb20u
YyB8IDEgKwogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspCgpkaWZmIC0tZ2l0IGEvYXJj
aC9wb3dlcnBjL2tlcm5lbC9wcm9tLmMgYi9hcmNoL3Bvd2VycGMva2VybmVsL3Byb20uYwppbmRl
eCAzMDhjNWUxLi5lYTJjZWE3IDEwMDY0NAotLS0gYS9hcmNoL3Bvd2VycGMva2VybmVsL3Byb20u
YworKysgYi9hcmNoL3Bvd2VycGMva2VybmVsL3Byb20uYwpAQCAtODAwLDYgKzgwMCw3IEBAIGlu
dCBvZl9nZXRfaWJtX2NoaXBfaWQoc3RydWN0IGRldmljZV9ub2RlICpucCkKIAl9CiAJcmV0dXJu
IC0xOwogfQorRVhQT1JUX1NZTUJPTChvZl9nZXRfaWJtX2NoaXBfaWQpOwogCiAvKioKICAqIGNw
dV90b19jaGlwX2lkIC0gUmV0dXJuIHRoZSBjcHVzIGNoaXAtaWQKLS0gCjIuMS4wCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eHBwYy1kZXYgbWFp
bGluZyBsaXN0CkxpbnV4cHBjLWRldkBsaXN0cy5vemxhYnMub3JnCmh0dHBzOi8vbGlzdHMub3ps
YWJzLm9yZy9saXN0aW5mby9saW51eHBwYy1kZXY=
