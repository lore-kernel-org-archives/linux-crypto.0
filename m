From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/2] crypto: testmgr - clean alg_test_null entries in
 alg_test_descs[]
Date: Tue, 13 Nov 2012 11:47:37 +0200
Message-ID: <20121113094737.25071.88732.stgit@localhost6.localdomain6>
References: <20121113094732.25071.31295.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:46192 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab2KMJrk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Nov 2012 04:47:40 -0500
In-Reply-To: <20121113094732.25071.31295.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently alg_test_null entries set .suite values to zero, which is unneeded.
So perform clean-up of null test entries.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/testmgr.c |  372 ------------------------------------------------------
 1 file changed, 372 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index b8695bf..37b4c07 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1638,300 +1638,66 @@ static const struct alg_test_desc alg_test_descs[] = {
 	{
 		.alg = "__cbc-cast5-avx",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "__cbc-cast6-avx",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "__cbc-serpent-avx",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "__cbc-serpent-sse2",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "__cbc-twofish-avx",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "__driver-cbc-aes-aesni",
 		.test = alg_test_null,
 		.fips_allowed = 1,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "__driver-cbc-camellia-aesni",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "__driver-cbc-cast5-avx",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "__driver-cbc-cast6-avx",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "__driver-cbc-serpent-avx",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "__driver-cbc-serpent-sse2",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "__driver-cbc-twofish-avx",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "__driver-ecb-aes-aesni",
 		.test = alg_test_null,
 		.fips_allowed = 1,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "__driver-ecb-camellia-aesni",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "__driver-ecb-cast5-avx",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "__driver-ecb-cast6-avx",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "__driver-ecb-serpent-avx",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "__driver-ecb-serpent-sse2",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "__driver-ecb-twofish-avx",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "__ghash-pclmulqdqni",
 		.test = alg_test_null,
 		.fips_allowed = 1,
-		.suite = {
-			.hash = {
-				.vecs = NULL,
-				.count = 0
-			}
-		}
 	}, {
 		.alg = "ansi_cprng",
 		.test = alg_test_cprng,
@@ -2160,165 +1926,39 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "cryptd(__driver-cbc-aes-aesni)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "cryptd(__driver-cbc-camellia-aesni)",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "cryptd(__driver-ecb-aes-aesni)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "cryptd(__driver-ecb-camellia-aesni)",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "cryptd(__driver-ecb-cast5-avx)",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "cryptd(__driver-ecb-cast6-avx)",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "cryptd(__driver-ecb-serpent-avx)",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "cryptd(__driver-ecb-serpent-sse2)",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "cryptd(__driver-ecb-twofish-avx)",
 		.test = alg_test_null,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "cryptd(__driver-gcm-aes-aesni)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "cryptd(__ghash-pclmulqdqni)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
-		.suite = {
-			.hash = {
-				.vecs = NULL,
-				.count = 0
-			}
-		}
 	}, {
 		.alg = "ctr(aes)",
 		.test = alg_test_skcipher,
@@ -2489,18 +2129,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "ecb(__aes-aesni)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
-		.suite = {
-			.cipher = {
-				.enc = {
-					.vecs = NULL,
-					.count = 0
-				},
-				.dec = {
-					.vecs = NULL,
-					.count = 0
-				}
-			}
-		}
 	}, {
 		.alg = "ecb(aes)",
 		.test = alg_test_skcipher,
